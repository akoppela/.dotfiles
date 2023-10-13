{ config, pkgs, lib, ... }:

let
  cfg = config.my-os;
in
{
  options.my-os = {
    configPath = lib.mkOption {
      description = "Path to the OS configuration";
      type = lib.types.str;
      default = "/etc/nixos/configuration.nix";
    };
  };

  config = {
    nix.settings.max-jobs = lib.mkDefault 1;
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nix.settings.warn-dirty = false;
    nix.nixPath = lib.mkDefault [
      "nixos-config=${cfg.configPath}"
      "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];

    # Set locales and key maps
    i18n.defaultLocale = "en_US.UTF-8";
    console.earlySetup = true;
    console.keyMap = lib.mkDefault "us";
    console.useXkbConfig = config.services.xserver.enable;
  };
}
