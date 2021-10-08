{
  imports = [
    ./hardware.nix
    ./networking.nix
    ../default.nix
    ../users/akoppela.nix
  ];

  # General
  my-os.configPath = "/home/akoppela/.dotfiles/nix/os/nano/default.nix";
  networking.hostName = "nano";
  time.timeZone = "Europe/Moscow";
  nix.maxJobs = 6;

  # Enable X server
  services.xserver.enable = true;
  services.xserver.dpi = 160;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05";
}
