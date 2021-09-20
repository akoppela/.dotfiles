{ config, pkgs, lib, ... }:

{
  imports =
    [ ./default.nix
      <nixpkgs/nixos/modules/installer/virtualbox-demo.nix>
      ./config/networking.nix
      ./users/akoppela.nix
    ];

  my-os = {
    hostName = "vbox-nixos";
    timeZone = "Europe/Moscow";
    configPath = "/home/akoppela/.dotfiles/nix/os/vbox.nix";
  };

  nix.trustedUsers = [ "demo" "akoppela" ];

  # By default, the NixOS VirtualBox demo image includes SDDM and Plasma.
  # If you prefer another desktop manager or display manager, you may want
  # to disable the default.
  services.xserver.desktopManager.plasma5.enable = lib.mkForce false;
  services.xserver.displayManager.sddm.enable = lib.mkForce false;

  # Enable EXWM and StartX
  services.xserver.windowManager.exwm.enable = true;
  # services.xserver.displayManager.startx.enable = true;
}