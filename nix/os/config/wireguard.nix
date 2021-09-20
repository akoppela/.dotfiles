{ config, pkgs, lib, ... }:

let
  cfg = config.networking.my-wireguard;
in
{
  imports = [
    ./networking.nix
  ];

  options.my-wireguard = {
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
      interfaces = {
        "${cfg.internalInterface}" = {
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
          privateKeyFile = "${/root/.config/wireguard/private}";
          generatePrivateKeyFile = true;

          # List of allowed peers
          peers = [
            # iPad
            {
              publicKey = "V89k5btlMR1IVokswq45ARLRfkeFG6wFkW7RwKWG6lM=";
              allowedIPs = [ "10.100.0.2/32" ];
            }
            # Zi's phone
            {
              publicKey = "bxkrVLoDBuLlqIwsq4hAln8l4BJ9mB83GM/PQviqpS8=";
              allowedIPs = [ "10.100.0.3/32" ];
            }
          ];
        };
      };
    };
  };
}
