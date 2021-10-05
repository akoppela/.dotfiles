{
  imports = [
    ./hardware.nix
    ./power-management.nix
    ./networking.nix
    ../default.nix
    ../users/akoppela.nix
  ];

  my-os = {
    hostName = "nano";
    configPath = "/home/akoppela/.dotfiles/nix/os/nano/default.nix";
    timeZone = "Europe/Moscow";
  };

  # Enable X server
  services.xserver.enable = true;

  # Enable auto screen lock
  services.physlock.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05";
}
