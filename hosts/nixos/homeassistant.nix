{
  services.home-assistant = {
    enable = true;
    extraComponents = [
      # Components required to complete the onboarding
      "esphome"
      "met"
      "radio_browser"
      "mqtt"
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
