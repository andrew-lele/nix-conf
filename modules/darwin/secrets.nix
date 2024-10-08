{ config, pkgs, agenix, secrets, ... }:

let user = "le"; in
{
  age.identityPaths = [ 
    "/Users/${user}/.ssh/id_ed25519"
  ];

  # Your secrets go here
  #
  # Note: the installWithSecrets command you ran to boostrap the machine actually copies over
  #       a Github key pair. However, if you want to store the keypair in your nix-secrets repo
  #       instead, you can reference the age files and specify the symlink path here. Then add your
  #       public key in shared/files.nix.
  #
  #       If you change the key name, you'll need to update the SSH extraConfig in shared/home-manager.nix
  #       so Github reads it correctly.

  #
  age.secrets = {
    "github-ssh-key" = {
      symlink = false;
      path = "/Users/${user}/.ssh/id_github";
      file =  "${secrets}/github-ssh-key.age";
      mode = "400";
      owner = "${user}";
      group = "wheel";
    };
    "github-signing-key" = {
      symlink = false;
      path = "/Users/${user}/.ssh/pgp_github.pgp";
      file =  "${secrets}/github-signing-key.age";
      mode = "400";
      owner = "${user}";
      group = "wheel";
    };
  };
}
