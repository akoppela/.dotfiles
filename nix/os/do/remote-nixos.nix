{ config, pkgs, lib, ... }:

{
  imports = [
    ./default.nix
    ../users/akoppela.nix
    ../config/wireguard.nix
  ];

  my-os = {
    hostName = "remote-nixos";
    configPath = "/home/akoppela/.dotfiles/nix/os/do/remote-nixos.nix";
    timeZone = "Europe/Amsterdam";
  };

  # Enable my WireGuard configuration
  networking.my-wireguard = {
    enable = true;
    externalInterface = config.networking.do.externalInterface;
  };

  # Enable Docker
  virtualisation.docker.enable = true;
}
