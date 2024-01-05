{
  description = "akoppela's flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, home-manager, ... }: {
    nixosConfigurations = {
      nano = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit home-manager;
        };

        modules = [
          ./nix/os/nano/default.nix
        ];
      };
    };
  } // flake-utils.lib.eachDefaultSystem (system: {
    devShells.default = import ./shell.nix { inherit system nixpkgs; };
  });
}
