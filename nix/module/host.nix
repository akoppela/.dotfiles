{ config, pkgs, lib, ... }:

{
  nix.settings.max-jobs = lib.mkDefault 1;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;
  nix.settings.warn-dirty = false;

  i18n.defaultLocale = "en_US.UTF-8";
  console.earlySetup = true;
  console.keyMap = lib.mkDefault "us";
  console.useXkbConfig = config.services.xserver.enable;
  console.packages = [ pkgs.spleen ];
  console.font = "spleen-16x32";

  fonts.fontconfig.antialias = true;
  fonts.fontconfig.hinting.enable = true;
  fonts.fontconfig.hinting.autohint = true;

  # Monokai Pro theme
  console.colors = [
    "363537"
    "ff6188"
    "a9dc76"
    "ffd866"
    "fc9867"
    "ab9df2"
    "78dce8"
    "fdf9f3"
    "908e8f"
    "ff6188"
    "a9dc76"
    "ffd866"
    "fc9867"
    "ab9df2"
    "78dce8"
    "fdf9f3"
  ];
}
