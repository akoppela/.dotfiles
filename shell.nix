let
  pkgs = import (fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-22.05") { };
in
pkgs.mkShell {
  buildInputs = [
    # NIX
    pkgs.nixpkgs-fmt
    pkgs.nixops_unstable
  ];

  AWS_SHARED_CREDENTIALS_FILE = "~/.config/aws/credentials";
  DIGITAL_OCEAN_AUTH_TOKEN = builtins.readFile ./secret/do-auth-token;
}
