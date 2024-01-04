{
  network.description = "DO Psyberia: NixOS";
  network.storage.legacy = {
    databasefile = "~/.nixops/deployments.nixops";
  };

  do-psyberia = { config, ... }: {
    imports = [
      ../default.nix
      ./networking.nix # generated at runtime by nixos-infect
      ../../config/wireguard.nix
    ];

    # Physical configuration
    deployment = {
      targetHost = "128.199.16.170";
    };

    networking.hostName = "psyberia-nixos";
    time.timeZone = "Asia/Bangalore";

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
        # iPhone
        {
          publicKey = "uiBEuWMz3wl1HqCVCuljSY/zoKG5SKT5iMtPYc4gOmM=";
          allowedIPs = [ "10.100.0.5/32" ];
        }
        # Nano
        {
          publicKey = "ZnXsoUG4lNbIG8P4RNXT1IIqqsivb0upSSZ4lnSAoHw=";
          allowedIPs = [ "10.100.0.6/32" ];
        }
        # Tima's phone
        {
          publicKey = "HloR2iQkA1eTM60ksn3mvmClIHSGNCD8T8dfYSBpyh4=";
          allowedIPs = [ "10.100.0.7/32" ];
        }
        # Zi's iPad
        {
          publicKey = "4bpHKkn25wTswP7uEon886GcfEUHJAiw9EL9q9M5ZCI=";
          allowedIPs = [ "10.100.0.8/32" ];
        }
        # Zi's Macbook
        {
          publicKey = "gO27vLZy/pXpiml71tD0S7u5iGlS3y87Wuygzx2QADk=";
          allowedIPs = [ "10.100.0.9/32" ];
        }
        # Tima's iPhone X
        {
          publicKey = "/m7Pl8tvGp7M9YqTv04OE5PTF6xIaBjGEDiP74YijgQ=";
          allowedIPs = [ "10.100.0.10/32" ];
        }
        # Leo's phone
        {
          publicKey = "vaTsunHz1Ep9DDOq8U5R9f44e1Xs4yN2q7jijbmztBI=";
          allowedIPs = [ "10.100.0.11/32" ];
        }
        # Mama's phone
        {
          publicKey = "nirzrlImv4Ed68iT8xwTmOz5SfJngfWeKQFVEXOUYHo=";
          allowedIPs = [ "10.100.0.12/32" ];
        }
      ];
    };

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "21.05";
  };
}
