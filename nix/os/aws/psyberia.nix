let
  region = "ap-southeast-1";
  accessKeyId = "psyberia";
  externalNetworkInterface = "eth0";
in
{
  network.description = "AWS Psyberia";

  resources = {
    ec2KeyPairs.awsPsyberiaKeyPair = { inherit region accessKeyId; };
    elasticIPs.awsPsyberiaIP = { inherit region accessKeyId; };
    ec2SecurityGroups.awsPsyberiaSecurityGroup = {
      inherit region accessKeyId;

      name = "aws-psyberia-security-group";
      description = "AWS Psyberia Security Group";
      rules = [
        # Allow everything in favor of locally managed firewall
        { fromPort = -1; toPort = -1; protocol = "-1"; sourceIp = "0.0.0.0/0"; }
      ];
    };
  };

  psyberia = { resources, ... }: {
    imports = [
      ../default.nix
      ../config/networking.nix
      ../config/wireguard.nix
    ];

    nix.autoOptimiseStore = true;
    networking.hostName = "aws-psyberia";
    time.timeZone = "Asia/Singapore";

    networking.firewall.allowedTCPPorts = [
      22 # SSH
      80 # HTTP
      443 # HTTPS
    ];

    # Automatically setup networking interfaces
    networking.useDHCP = false; # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    networking.interfaces."${externalNetworkInterface}".useDHCP = true;

    # Enable Proxy
    services.nginx.enable = true;

    # Enable VPN
    networking.my-wireguard = {
      enable = true;
      externalInterface = externalNetworkInterface;
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
        # Mac Mini
        {
          publicKey = "887qybTrWu/c+HkqnATB5ZkrdSai1IbyJhBpO6MeW0Y=";
          allowedIPs = [ "10.100.0.4/32" ];
        }
        # iPhone
        {
          publicKey = "5PbluhEgm5ptdi9803RcSNPUGKYb2grsKAAlXm17vAE=";
          allowedIPs = [ "10.100.0.5/32" ];
        }
        # Nano
        {
          publicKey = "ZnXsoUG4lNbIG8P4RNXT1IIqqsivb0upSSZ4lnSAoHw=";
          allowedIPs = [ "10.100.0.6/32" ];
        }
      ];
    };

    # Physical configuration
    deployment = {
      targetEnv = "ec2";
      ec2 = {
        inherit region accessKeyId;

        instanceType = "t2.micro";
        keyPair = resources.ec2KeyPairs.awsPsyberiaKeyPair;
        elasticIPv4 = resources.elasticIPs.awsPsyberiaIP;
        securityGroups = [ resources.ec2SecurityGroups.awsPsyberiaSecurityGroup ];
      };
    };

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "21.11";
  };
}