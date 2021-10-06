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
    nix.maxJobs = lib.mkDefault 1;
    nix.nixPath = lib.mkDefault [
      "nixos-config=${cfg.configPath}"
      "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];

    # Enable Nix Flakes
    environment.systemPackages = [
      (pkgs.writeShellScriptBin "nixFlakes" ''
        exec ${pkgs.nixUnstable}/bin/nix --experimental-features "nix-command flakes" "$@"
      '')
    ];

    # Set locales and key maps
    i18n.defaultLocale = "en_US.UTF-8";
    console.keyMap = lib.mkDefault "us";

    # The NixOS release to be compatible with for stateful data such as databases.
    system.stateVersion = lib.mkDefault "20.03";
  };
}
