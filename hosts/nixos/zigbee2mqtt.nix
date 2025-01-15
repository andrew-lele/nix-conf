{
  config,
  ...
}:
let
  ports = import ./custom-ports.nix;
in
{
  services = {
    zigbee2mqtt = {
      enable = true;
      settings = {
        homeassistant = true;
        # homeassistant = {
        #   enabled = true;
        # };
        frontend = {
          enabled = true;
          port = ports.z2mFrontend;
          url = "z2m.andle.day";
        };
        permit_join = false;
        availability = true;
        serial = {
          port = "/dev/ttyUSB0";
        };
        mqtt = {
          server = "mqtt://localhost:1883";
        };
        devices = {
          "0x3425b4fffe16f7ab" = {
            friendly_name = "ir-remote";
          };
        };
      };
    };
    mosquitto = {
      enable = true;
      listeners = [
        {
          acl = [ "topic readwrite #" ];
          port = ports.mqtt;
          address = "0.0.0.0";
          omitPasswordAuth = true;
          settings.allow_anonymous = true;
        }
      ];
    };
  };
}
