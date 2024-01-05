{ system, nixpkgs, ... }:

let
  pkgs = import nixpkgs { inherit system; };
in
pkgs.mkShell {
  buildInputs = [
    # NIX
    pkgs.nixpkgs-fmt
    pkgs.nixops_unstable
  ];
}
