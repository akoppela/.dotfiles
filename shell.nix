let
  pkgs = import (fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-21.05") { };
in
pkgs.mkShell {
  buildInputs = [
    # NIX
    pkgs.nixpkgs-fmt
    pkgs.nixops
  ];

  DIGITAL_OCEAN_AUTH_TOKEN = builtins.readFile ./nix/os/do/auth-token;
}
