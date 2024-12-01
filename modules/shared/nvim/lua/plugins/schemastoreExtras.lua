-- this file doesn't work :(
local extras = {
	{
		description = "Cilium.. what more",
		fileMatch = "templates/*.yaml",
		name = "Cilium",
		url = "https://raw.githubusercontent.com/cilium/cilium/refs/heads/main/install/kubernetes/cilium/values.schema.json",
	},
}
return {
	"neovim/nvim-lspconfig",
	opts = {
		-- make sure mason installs the server
		servers = {
			yamlls = {
				-- Have to add this for yamlls to understand that we support line folding
				-- lazy-load schemastore when needed
				on_new_config = function(new_config)
					new_config.settings.yaml.schemas = vim.tbl_deep_extend(
						"force",
						new_config.settings.yaml.schemas or {},
						require("schemastore").yaml.schemas()({ extra = extras })
					)
				end,
			},
		},
	},
}
