{ config, pkgs, lib, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/virtualisation/virtualbox-image.nix>
    ./default.nix
    ./config/networking.nix
    ./users/akoppela.nix
  ];

  my-os = {
    hostName = "vbox-nixos";
    timeZone = "Europe/Moscow";
    configPath = "/home/akoppela/.dotfiles/nix/os/vbox.nix";
  };

  # Enable GUI
  akoppela.enableX = true;

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
}