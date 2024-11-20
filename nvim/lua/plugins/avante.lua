local role_map = {
	user = "human",
	assistant = "assistant",
	system = "system",
}
local parse_messages = function(opts)
	local messages = {
		{ role = "system", content = opts.system_prompt },
	}
	vim.iter(opts.messages):each(function(msg)
		table.insert(messages, { speaker = role_map[msg.role], text = msg.content })
	end)
	return messages
end

local parse_response_data = function(data_stream, event_state, opts)
	if event_state == "done" then
		opts.on_complete()
		return
	end

	if data_stream == nil or data_stream == "" then
		return
	end

	local json = vim.json.decode(data_stream)
	local delta = json.deltaText
	local stopReason = json.stopReason

	if stopReason == "end_turn" then
		return
	end

	opts.on_chunk(delta)
end
return {
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		build = "make",
		opts = {
			-- add any opts here
			provider = "cody",
			vendors = {
				---@type AvanteProvider
				["cody"] = {
					endpoint = os.getenv("SRC_ENDPOINT"),
					model = "google::2024-06-20::claude-3-5-sonnet-45k-Tokens",
					api_key_name = "SRC_ACCESS_TOKEN",
					--- This function below will be used to parse in cURL arguments.
					--- It takes in the provider options as the first argument, followed by code_opts retrieved from given buffer.
					--- This code_opts include:
					--- - question: Input from the users
					--- - code_lang: the language of given code buffer
					--- - code_content: content of code buffer
					--- - selected_code_content: (optional) If given code content is selected in visual mode as context.
					---@type fun(opts: AvanteProvider, code_opts: AvantePromptOptions): AvanteCurlOutput
					parse_curl_args = function(opts, code_opts)
						local headers = {
							["Content-Type"] = "application/json",
							["Authorization"] = "token " .. os.getenv(opts.api_key_name),
						}

						return {
							url = opts.endpoint
								.. "/.api/completions/stream?api-version=2&client-name=web&client-version=0.0.1",
							timeout = 30000,
							insecure = false,
							headers = headers,
							body = vim.tbl_deep_extend("force", {
								model = opts.model,
								temperature = 0,
								topK = -1,
								topP = -1,
								maxTokensToSample = 4000,
								stream = true,
								messages = parse_messages(code_opts),
							}, {}),
						}
					end,
					parse_response_data = parse_response_data,
					parse_messages = parse_messages,
				},
			},
		},
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			--- The below dependencies are optional,
			"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
			"zbirenbaum/copilot.lua", -- for providers='copilot'
			{
				-- support for image pasting
				"HakonHarnes/img-clip.nvim",
				event = "VeryLazy",
				opts = {
					-- recommended settings
					default = {
						embed_image_as_base64 = false,
						prompt_for_file_name = false,
						drag_and_drop = {
							insert_mode = true,
						},
						-- required for Windows users
						use_absolute_path = true,
					},
				},
			},
			{
				-- Make sure to set this up properly if you have lazy=true
				"MeanderingProgrammer/render-markdown.nvim",
				opts = {
					file_types = { "markdown", "Avante" },
				},
				ft = { "markdown", "Avante" },
			},
		},
	},

	{
		"folke/which-key.nvim",
		optional = true,
		opts = {
			spec = {
				{ "<leader>a", group = "+ai", icon = { icon = "ﮧ", hl = "false" } },
				{ "<leader>aa", "<cmd>AvanteAsk<cr>", desc = "ask", icon = { icon = "", hl = "false" } },
				{ "<leader>ar", "<cmd>AvanteRefresh<cr>", desc = "refresh", icon = { icon = "", hl = "false" } },
			},
		},
	},
}
