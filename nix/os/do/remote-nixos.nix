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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05";
}
