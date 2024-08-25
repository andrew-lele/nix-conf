{ pkgs, config, ... }:

let

 githubSigningKey = ''
 -----BEGIN PGP PUBLIC KEY BLOCK-----

mDMEZaYSQxYJKwYBBAHaRw8BAQdAggq+Pa7V8fNM9oQoI+eR6R8bSAD5Ys9qVmwN
P04CDXi0PGFuZHJldyAoZ3BnIGtleS4gZ2VuZXJhdGVkIGZvciBuaXgpIDxhbmRy
ZXcubGUxOTdAZ21haWwuY29tPoiTBBMWCgA7FiEEcr6wEAT1Ppan79PC/49MXSop
ErgFAmWmEkMCGwMFCwkIBwICIgIGFQoJCAsCBBYCAwECHgcCF4AACgkQ/49MXSop
Ergu3QD9GNGqxU4dRK7JoRY2CE3YVzmCitBUHSXpiCYs5jRB1QAA/RRMbtcBdjON
TC04iX4aorbvU1RnM0Ijgy3a9as1VmoKuDgEZaYSQxIKKwYBBAGXVQEFAQEHQJHd
74eL+PsiNra8oAb8CiFwnI37nmTV1NnNNr0LYcRLAwEIB4h4BBgWCgAgFiEEcr6w
EAT1Ppan79PC/49MXSopErgFAmWmEkMCGwwACgkQ/49MXSopErha6gEAmbxp9iGS
7YG1JY1eSnR4NnTC+r851yrDe4c4axi3FWEBAKLS3RFv/hOPeNfz71I/6vAJMISM
ymIQPSZx612LNgsO
=TtRJ
-----END PGP PUBLIC KEY BLOCK-----
'';

in
{

  ".ssh/pgp_github.pub" = {
    text = githubSigningKey;
  };

  "./.config/nvim/lua" = {
    source = ./nvim/lua;
    recursive = true;
  };
# Initializes Emacs with org-mode so we can tangle the main config
#  ".emacs.d/init.el" = {
#    text = builtins.readFile ../shared/config/emacs/init.el;
#  };
}
