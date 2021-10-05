{ config, pkgs, lib, ... }:

{
  imports = [
    ./default.nix
    ../users/akoppela.nix
    ../config/wireguard.nix
  ];

  # General
  my-os.configPath = "/home/akoppela/.dotfiles/nix/os/do/remote-nixos.nix";
  networking.hostName = "remote-nixos";
  time.timeZone = "Europe/Amsterdam";

  # Enable my WireGuard configuration
  networking.my-wireguard = {
    enable = true;
    externalInterface = config.networking.do.externalInterface;
  };

  # Enable Docker
  virtualisation.docker.enable = true;
}
