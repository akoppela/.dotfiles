{
  description = "akoppela's flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgsUnstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgsUnstable, home-manager, ... }:
    let
      pkgs = import nixpkgs { inherit system; };
      pkgsUnstable = import nixpkgsUnstable { inherit system; };
      system = "x86_64-linux";
    in
    {
      devShells."${system}".default = pkgs.mkShell {
        buildInputs = [
          pkgs.nixpkgs-fmt
          pkgs.nixops_unstable_minimal
        ];
      };

      nixosConfigurations = {
        nano = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit home-manager pkgsUnstable;
          };

          modules = [
            ./nix/host/nano/default.nix
          ];
        };

        p16s = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit home-manager pkgsUnstable;
          };

          modules = [
            ./nix/host/p16s/default.nix
          ];
        };
      };
    };
}
