{
  lib,
  ...
}:

let
  inherit (lib) mkOption types;
in

{
  options.my = {
    user = mkOption { type = types.str; };
    name = mkOption { type = types.str; };
    email = mkOption { type = types.str; };
    uid = mkOption { type = types.int; };
    keys = mkOption { type = types.listOf types.singleLineStr; };
    domain = mkOption { type = types.str; };
  };

  config = {
    self = {
      user = "le";
      name = "Andrew Le";
      email = "le@andle.me";
      uid = 1000;
      keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOk8iAnIaa1deoc7jw8YACPNVka1ZFJxhnU4G74TmS+p"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCul+vpn+aybmohQMZ9IuRoZsqJHRyJ42UahkzwqQbgkNFnrnuXVx0vIXLW2il0jORFb+i5j337Ps7A+XkFUccH3UyqIWiUl62N5Bn37uLeP37lmtcAyTQ2avLG052lWY8h+yJUezRd9wCSHj7GBn0pyY8f8t7CbqwzUDLUbG4U1yQhXdnG/Agrcm7BZsa0GfqRqH+kqYVfESritBQpJvB6IkPP1dG8iFOrzMoTQvvmOC5937QHpUOIwO+4Vu9cldWBhtJT+XcW5SYw8KRyihwTUpvPIfqAzx/HjtxcuwJmN+JRBK5P/Vy36kK6ip882PnNvlsGrqUYxMM/d/lRZV23YsGHSAZPjK0pykJTB2NyTaJiNit6gCzj8za18ak4c7dTYsy8fhifZ7zh/u7H4e+a6XPG5KNHs0Hx3D+7qE1da4dWXXnvxksDwRIHRTCFmgHdxg7A3Q056T4bOzdGZDFcRHw2CmXW+uAD2kwKqbvP0sm35H36qbJBwBJI0Q0Ry7c= le@mac.self"
      ];
      domain = "andle.me";
    };
  };
}
