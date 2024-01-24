{
  description = "akoppela's flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
      ];
    in
    {
      devShells = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default = pkgs.mkShell {
            buildInputs = [
              pkgs.nixpkgs-fmt
              pkgs.nixops_unstable
            ];
          };
        }
      );

      nixosConfigurations = {
        nano = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit home-manager;
          };

          modules = [
            ./nix/host/nano/default.nix
          ];
        };

        p16s = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit home-manager;
          };

          modules = [
            ./nix/host/p16s/default.nix
          ];
        };
      };
    };
}
