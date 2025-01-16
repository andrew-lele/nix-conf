let
  makeIrScript = alias: irCode: {
    alias = alias;
    sequence = [
      {
        service = "mqtt.publish";
        data = {
          payload = ''
            {"ir_code_to_send": "${irCode}"}
          '';
          topic = "zigbee2mqtt/ir-remote/set";
        };
      }
    ];
    mode = "parallel";
  };
in
{
  services.home-assistant = {
    enable = true;
    extraComponents = [
      # Components required to complete the onboarding
      "esphome"
      "met"
      "radio_browser"
      "mqtt"
      "zha"
    ];
    extraPackages =
      python3Packages: with python3Packages; [
        # recorder postgresql support
        # psycopg2

        gtts
      ];
    config = {
      # Includes dependencies for a basic setup
      # https://www.home-assistant.io/integrations/default_config/
      script = {
        test = makeIrScript "Amp: Volume Up" "B3gjZxFaAiQCQANAAUAH4AEDAogGJCAD4BEHACSgAUAjAyQCWgJAB8ADQA/gAwNAF+ABDwEkAkAPwAMJ1pp4I7gIWgL//+ACBwIIWgI=";
        amp1 = makeIrScript "Amp: Power" "BpYjZhFqAh3gAAFAC0ADQAEDagJpBuAVA0AjwAPAK8AP4AMHQBvAD0AL4AUDCx0C4JqWI6gIHQL//0AHCWoC//+WI6gIagI=";
        amp2 = makeIrScript "Amp: Volume Down" "BoMjbBFqAjdgAeAHBwQ3AnoGaiADQAfAA+AFDwQ3AmoCN2ABAWoCgBtABwA3YAsANyABQAsDNwJqAoAHQAECagI3oAEBegaAC0AHCduagyO5CDcC///gAgcCCGoC";
        amp3 = makeIrScript "Amp: A4" "CX0jgBE2AjYCZwKAA0ABwAsDZwKDBuADAwA2IA/AA0AXATYCwAFAC+AHA+ANAQJnAjagAQKDBmcgA4AHCd2afSPTCDYC///gCgcCCGcC";
        fireplace1 = makeIrScript "Fireplace: Power" "A/kElAFAAwa8AfkE+QSUIAUBlAFACwOUAfkEQAcD+QSUAUAHgAMFPiH5BJQBQAMFvAH5BPkEQAWAC0AJQAMB+QSADwCUIB8BvAHgBy9AFQOUAbwBQAUB+QRABwP5BJQBQAeAA+ARLwG8AYADBfkEvAGUAUAFQAPgCy8BvAHgAR8F+QT5BJQBQAeAA+ABLwaUAfkE+QS8IAUBvAFACwO8AfkEQAcD+QS8AUAHAbwBQANALwu8AfkElAGUAfkE+QRACwG8AUALAbwBgAMD+QS8AcAPAZQBQC8LlAH5BLwBvAH5BPkEQAsBlAFACwOUAfkEQAcD+QSUAUAHgAPgAS8GlAH5BPkEvCAFAbwBQAvAAwL5BJTgAg9ALwG8AUADBZQB+QT5BEAFgAtACUADAfkE4AMP4AcvAbwBQAMDlAH5BMADDfkEvAGUAfkElAH5BJQB";
        fireplace2 = makeIrScript "Fireplace: Heat" "DQEFoQEBBaEBoQEBBQEFQAUFoQHZAQEFQAMCoQEBYAMGAQWhAaEBASAFAo0hASAFAAEgA0AfBAEFoQEBIAMCoQEBIAUAAWADwBdABwGhAeABLwWhAQEFAQVABQWhAaEBAQVAH0ADQAsGAQWhAaEBASAF4AcvgCEDoQEBBeADAwYBBaEBoQEBIAXALwfZAaEBAQUBBUAFBKEBoQEBIAUAAeAAAwYBBaEB2QEBIAXALwehAaEBAQUBBUAFBKEBoQEBIAUAAWADQCcGAQWhAaEBASAF4AcvQB0F2QGhAQEF4AMDBgEFoQGhAQEgBeALLwShAaEBASAFAAHgAAMBAQXAQ0AvAtkBASADCKEBAQUBBdkBASADQAtAAwNdAQEFQAcDAQXZAUALAV0B4AEvBV0BAQUBBUAdgAtACUADgBeAEwFdAeAHLwLZAQEgAwNdAQEF4AMDAQEFwBPgFS8JHAEBBV0BAQVMBIAvBxwBjSFMBEMCQAMDHAEBBUAHQANAC+ABAwHeBYATA94FHAHgAS8JwwDeBUwEtAJMBIALQA8AnCATCZwA3gVMBLQCVwA=";
      };
      ## REF
      #
      # "Amp: Volume Up" = {
      #   alias = "Amp: Volume Up";
      #   sequence = [
      #     {
      #       service = "mqtt.publish";
      #       data = {
      #         payload = ''
      #           {"ir_code_to_send": "B3gjZxFaAiQCQANAAUAH4AEDAogGJCAD4BEHACSgAUAjAyQCWgJAB8ADQA/gAwNAF+ABDwEkAkAPwAMJ1pp4I7gIWgL//+ACBwIIWgI="}
      #         '';
      #         topic = "zigbee2mqtt/IR remote/set";
      #       };
      #     }
      #   ];
      #   mode = "single";
      # };
      ## END REF
      # script = [
      #   {
      #     alias = "Amp: Volume Up";
      #     sequence = [
      #       {
      #         service = "mqtt.publish";
      #         data = {
      #           topic = "zigbee2mqtt/IR remote/set";
      #           payload = {
      #             ir_code_to_send = "B3gjZxFaAiQCQANAAUAH4AEDAogGJCAD4BEHACSgAUAjAyQCWgJAB8ADQA/gAwNAF+ABDwEkAkAPwAMJ1pp4I7gIWgL//+ACBwIIWgI=";
      #           };
      #         };
      #       }
      #     ];
      #     mode = "single";
      #   }
      # ];
      default_config = { };
      http = {
        server_host = "jihun.andle.day";
        trusted_proxies = [
          "192.168.55.1"
          "10.1.30.1"
        ];
        use_x_forwarded_for = true;
      };
    };
  };
}
