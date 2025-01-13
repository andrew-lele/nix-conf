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
        homeassistant = {
          enabled = true;
        };
        frontend = {
          enabled = true;
          port = ports.z2mFrontend;
          url = "z2m.andle.day";
        };
        permit_join = true;
        serial = {
          port = "/dev/ttyUSB0";
        };
        mqtt = {
          server = "mqtt://localhost:1883";
          base_topic = "zigbee2mqtt";
        };
      };
    };
    mosquitto = {
      enable = true;
      listeners = [
        {
          port = ports.mqtt;
          omitPasswordAuth = true;
          settings.allow_anonymous = true;
        }
      ];
    };
  };
}
