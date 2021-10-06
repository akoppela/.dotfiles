{ config, pkgs, lib, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/virtualisation/virtualbox-image.nix>
    ./default.nix
    ./config/networking.nix
    ./users/akoppela.nix
  ];

  # General
  my-os.configPath = "/home/akoppela/.dotfiles/nix/os/vbox.nix";
  networking.hostName = "vbox-nixos";
  time.timeZone = "Europe/Moscow";

  # Enable X server
  services.xserver.enable = true;

  # FIXME: UUID detection is currently broken
  boot.loader.grub.fsIdentifier = "provided";

  # Allow mounting of shared folders.
  users.users.akoppela.extraGroups = [ "vboxsf" ];

  # Add some more video drivers to give X11 a shot at working in VMware and QEMU.
  services.xserver.videoDrivers = lib.mkOverride 40 [
    "virtualbox"
    "vmware"
    "cirrus"
    "vesa"
    "modesetting"
  ];

  powerManagement.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03";
}
