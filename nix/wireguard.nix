{ config, lib, pkgs, ... }:

let
  externalInterface = "ens3";
  internalInterface = "wg0";
  port = 51820;
in
{
  # enable NAT
  networking.nat.enable = true;
  networking.nat.externalInterface = externalInterface;
  networking.nat.internalInterfaces = [ internalInterface ];

  networking.firewall = {
    allowedUDPPorts = [ port ];
  };

  networking.wireguard.interfaces = {
    "${internalInterface}" = {
      # Determines the IP address and subnet of the server's end of the tunnel interface.
      ips = [ "10.100.0.1/24" ];

      # The port that WireGuard listens to. Must be accessible by the client.
      listenPort = port;

      # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
      # For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
      postSetup = ''
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o ${externalInterface} -j MASQUERADE
      '';

      # This undoes the above command
      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o ${externalInterface} -j MASQUERADE
      '';

      # Path to the private key file.
      privateKeyFile = "${/root/.config/wireguard/private}";
      generatePrivateKeyFile = true;

      # List of allowed peers.
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
}
