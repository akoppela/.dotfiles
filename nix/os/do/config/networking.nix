{ config, lib, ... }:

let
  cfg = config.networking.do;
in
{
  imports = [
    ../../config/networking.nix
  ];

  options.networking.do = {
    enable = lib.mkEnableOption "Default DO networking configuration";

    externalInterface = lib.mkOption {
      description = "External networking interface name";
      type = lib.types.str;
      default = "ens3";
    };
  };

  config = lib.mkIf cfg.enable {
    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    networking.useDHCP = false;
    networking.interfaces."${cfg.externalInterface}".useDHCP = true;
  };
}
