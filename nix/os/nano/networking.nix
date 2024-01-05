let
  wireguard = {
    interface = "wg0";
    port = 51820;
  };

  wifiInterface = "wlan0";
in
{
  imports = [
    ../config/networking.nix
  ];

  # Enables wireless support
  networking.interfaces."${wifiInterface}".useDHCP = true;
  networking.wireless.iwd = {
    enable = true;
    settings = {
      Settings = {
        AutoConnect = true;
        AlwaysRandomizeAddress = true;
      };
    };
  };
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
  };

  # Extra Conta hosts
  networking.extraHosts = ''
    127.0.0.1   conta.test
    127.0.0.1   api.conta.test
    127.0.0.1   app.conta.test
    127.0.0.1   gjest.conta.test
    127.0.0.1   dist.conta.test
    127.0.0.1   mysql.conta.test
  '';

  # Enable VPN
  networking.firewall.allowedUDPPorts = [ wireguard.port ];
  networking.wg-quick.interfaces."${wireguard.interface}" = {
    address = [ "10.100.0.6/24" ];
    dns = [ "1.1.1.1" "8.8.8.8" ];
    listenPort = wireguard.port;
    privateKeyFile = "/root/.config/wireguard/private";
    peers = [
      {
        # Public key of the server
        publicKey = "b+eJgKELR8XcZeGIBcviLDMAA1eatJutD6wVP3rUN2c=";
        # Forward all the traffic via VPN
        allowedIPs = [ "0.0.0.0/0" ];
        # Set this to the server IP and port
        endpoint = "128.199.16.170:51820";
        # Send keepalives every 25 seconds, important to keep NAT tables alive
        persistentKeepalive = 25;
      }
    ];
  };
}
