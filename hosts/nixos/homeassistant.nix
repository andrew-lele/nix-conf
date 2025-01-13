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
        "test" = {
          alias = "Amp: Volume Up";
          sequence = [
            {
              service = "mqtt.publish";
              data = {
                payload = ''
                  {"ir_code_to_send": "B3gjZxFaAiQCQANAAUAH4AEDAogGJCAD4BEHACSgAUAjAyQCWgJAB8ADQA/gAwNAF+ABDwEkAkAPwAMJ1pp4I7gIWgL//+ACBwIIWgI="}
                '';
                topic = "zigbee2mqtt/ir-remote/set";
              };
            }
          ];
          mode = "single";
        };
        "fireplace1" = {
          alias = "Fireplace: Power";
          sequence = [
            {
              service = "mqtt.publish";
              data = {
                payload = ''
                  {"ir_code_to_send": "A/kElAFAAwa8AfkE+QSUIAUBlAFACwOUAfkEQAcD+QSUAUAHgAMFPiH5BJQBQAMFvAH5BPkEQAWAC0AJQAMB+QSADwCUIB8BvAHgBy9AFQOUAbwBQAUB+QRABwP5BJQBQAeAA+ARLwG8AYADBfkEvAGUAUAFQAPgCy8BvAHgAR8F+QT5BJQBQAeAA+ABLwaUAfkE+QS8IAUBvAFACwO8AfkEQAcD+QS8AUAHAbwBQANALwu8AfkElAGUAfkE+QRACwG8AUALAbwBgAMD+QS8AcAPAZQBQC8LlAH5BLwBvAH5BPkEQAsBlAFACwOUAfkEQAcD+QSUAUAHgAPgAS8GlAH5BPkEvCAFAbwBQAvAAwL5BJTgAg9ALwG8AUADBZQB+QT5BEAFgAtACUADAfkE4AMP4AcvAbwBQAMDlAH5BMADDfkEvAGUAfkElAH5BJQB"}
                '';
                topic = "zigbee2mqtt/ir-remote/set";
              };
            }
          ];
          mode = "single";
        };
      };
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
