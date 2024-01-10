{ config, pkgs, lib, ... }:

let
  cfg = config.networking.my-wireguard;

  peerOpts = {
    options = {
      publicKey = lib.mkOption {
        description = "The base64 public key of the peer";
        type = lib.types.str;
      };

      allowedIPs = lib.mkOption {
        description = "List of IP (v4 or v6) addresses with CIDR masks";
        type = lib.types.listOf lib.types.str;
      };
    };
  };
in
{
  imports = [
    ./networking.nix
  ];

  options.networking.my-wireguard = {
    enable = lib.mkEnableOption "My WireGuard configuration";

    externalInterface = lib.mkOption {
      description = "Name of the external interface";
      type = lib.types.str;
    };

    internalInterface = lib.mkOption {
      description = "Name of the WireGuard interface";
      type = lib.types.str;
      default = "wg0";
    };

    port = lib.mkOption {
      description = "UPD WireGuard ports";
      type = lib.types.int;
      default = 51820;
    };

    peers = lib.mkOption {
      description = "List of allowed peers";
      type = lib.types.listOf (lib.types.submodule peerOpts);
    };
  };

  config = lib.mkIf cfg.enable {
    networking.nat.enable = true;
    networking.nat.externalInterface = cfg.externalInterface;
    networking.nat.internalInterfaces = [ cfg.internalInterface ];

    networking.firewall.allowedUDPPorts = [ cfg.port ];

    networking.wireguard = {
      enable = true;
      interfaces."${cfg.internalInterface}" = {
        ips = [ "10.100.0.1/24" ];

        listenPort = cfg.port;

        postSetup = ''
          ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o ${cfg.externalInterface} -j MASQUERADE
        '';

        postShutdown = ''
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o ${cfg.externalInterface} -j MASQUERADE
        '';

        privateKeyFile = "/root/.config/wireguard/private";
        generatePrivateKeyFile = true;

        peers = cfg.peers;
      };
    };
  };
}
