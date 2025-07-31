{
  network.description = "DO Psyberia: NixOS";
  network.storage.legacy = {
    databasefile = "~/.nixops/deployments.nixops";
  };

  do-psyberia = { config, ... }: {
    imports = [
      ../../module/wireguard.nix
      ../default.nix
      ./networking.nix # generated at runtime by nixos-infect
    ];

    # Physical configuration
    deployment = {
      targetHost = "167.99.73.196";
    };

    networking.hostName = "psyberia-nixos";
    time.timeZone = "Asia/Singapore";

    # # Enable Docker
    # virtualisation.docker.enable = true;

    # Enable Proxy
    services.nginx = {
      enable = true;
      recommendedOptimisation = true;
      recommendedTlsSettings = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;
      resolver.addresses = [ "8.8.8.8" ];
      appendHttpConfig = ''
        # Add HSTS header with preloading to HTTPS requests.
        # Adding this header to HTTP requests is discouraged
        map $scheme $hsts_header {
            https "max-age=63072000; includeSubdomains; preload";
        }
        add_header Strict-Transport-Security $hsts_header;

        # Enable CSP for your services.
        # add_header Content-Security-Policy "script-src 'self'; object-src 'none'; base-uri 'none';" always;

        # Minimize information leaked to other domains
        add_header 'Referrer-Policy' 'origin-when-cross-origin';

        # Allow embedding as frame only locally
        add_header X-Frame-Options SAMEORIGIN;

        # Prevent injection of code in other mime types (XSS Attacks)
        add_header X-Content-Type-Options nosniff;

        # Enable XSS protection of the browser
        # May be unnecessary when CSP is configured properly (see above)
        add_header X-XSS-Protection "1; mode=block";
      '';
    };

    # Enable VPN
    networking.my-wireguard = {
      enable = true;
      externalInterface = "eth0";
      peers = [
        # iPhone
        {
          publicKey = "B/ziclrDAyq0y8rK3e/3Blqq5JHB8NSmQvYYqKrFfAU=";
          allowedIPs = [ "10.100.0.2/32" ];
        }
        # Lenovo p16s
        {
          publicKey = "Th/o1x5/8rTke2W7C08dnp65DXF6VyMy7iN3dyxEeCA=";
          allowedIPs = [ "10.100.0.3/32" ];
        }
      ];
    };

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "23.11";
  };
}
