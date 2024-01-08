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
    # Enable NAT
    networking.nat.enable = true;
    networking.nat.externalInterface = cfg.externalInterface;
    networking.nat.internalInterfaces = [ cfg.internalInterface ];

    # Open WireGuard port
    networking.firewall.allowedUDPPorts = [ cfg.port ];

    # Enable WireGuard
    networking.wireguard = {
      enable = true;
      interfaces."${cfg.internalInterface}" = {
        # Determines the IP address and subnet of the server's end of the tunnel interface
        ips = [ "10.100.0.1/24" ];

        # The port that WireGuard listens to. Must be accessible by the client
        listenPort = cfg.port;

        # This allows the WireGuard server to route your traffic to the internet and hence be like a VPN
        # For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
        postSetup = ''
          ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o ${cfg.externalInterface} -j MASQUERADE
        '';

        # This undoes the above command
        postShutdown = ''
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o ${cfg.externalInterface} -j MASQUERADE
        '';

        # Path to the private key file
        privateKeyFile = "/root/.config/wireguard/private";
        generatePrivateKeyFile = true;

        # List of allowed peers
        peers = cfg.peers;
      };
    };
  };
}
