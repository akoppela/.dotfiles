{ config, lib, ... }:

let
  cfg = config.my-os;
in
{
  options.my-os = {
    hostName = lib.mkOption {
      description = "OS host name";
      type = lib.types.str;
    };

    configPath = lib.mkOption {
      description = "Path to the OS configuration";
      type = lib.types.str;
      default = "/etc/nixos/configuration.nix";
    };

    timeZone  = lib.mkOption {
      description = "Machine time zone";
      type = lib.types.str;
    };
  };

  config = {
    nix.maxJobs = lib.mkDefault 1;

    nix.nixPath = lib.mkDefault [
      "nixos-config=${cfg.configPath}"
      "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];

    console.keyMap = "us";
    i18n.defaultLocale = "en_US.UTF-8";
    networking.hostName = cfg.hostName;
    time.timeZone = cfg.timeZone;

    # The NixOS release to be compatible with for stateful data such as databases.
    system.stateVersion = lib.mkOptionDefault "20.03";
  };
}