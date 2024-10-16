{ lib, ... }:

{
  imports = [
    ../../module/host.nix
    ../../module/desktop.nix
    ../../module/docker.nix
    ../../module/akoppela.nix
    ../../module/cosmicsun.nix
    ./hardware.nix
    ./networking.nix
  ];

  networking.hostName = "p16s";
  time.timeZone = "Asia/Bangkok";
  nixpkgs.hostPlatform = "x86_64-linux";
  nix.settings.max-jobs = 6;

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "1password"
    "slack"
    "zoom"
    "roomeqwizard"
    "bitwig-studio"
  ];

  services.xserver.dpi = 141;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11";
}
