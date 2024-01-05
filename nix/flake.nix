{
  description = "akoppela's flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }: {
    nixosConfigurations = {
      nano = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit home-manager;
        };

        modules = [
          ./os/nano/default.nix
        ];
      };
    };
  };
}
