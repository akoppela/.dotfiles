{ lib, ... }: {
  networking = {
    defaultGateway = "128.199.16.1";
    defaultGateway6 = "";
    dhcpcd.enable = false;
    usePredictableInterfaceNames = lib.mkForce false;
    interfaces = {
      eth0 = {
        ipv4.addresses = [
          {
            address = "128.199.16.170";
            prefixLength = 20;
          }
          {
            address = "10.47.0.5";
            prefixLength = 16;
          }
        ];
        ipv6.addresses = [
          {
            address = "fe80::3c33:fcff:fee1:de46";
            prefixLength = 64;
          }
        ];
        ipv4.routes = [{
          address = "128.199.16.1";
          prefixLength = 32;
        }];
        ipv6.routes = [{
          address = "";
          prefixLength = 128;
        }];
      };

    };
  };

  services.udev.extraRules = ''
    ATTR{address}=="3e:33:fc:e1:de:46", NAME="eth0"
    ATTR{address}=="6e:61:77:f5:36:ae", NAME="eth1"
  '';
}
