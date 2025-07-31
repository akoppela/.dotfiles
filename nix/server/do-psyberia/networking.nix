{ lib, ... }: {
  # This file was populated at runtime with the networking
  # details gathered from the active system.
  networking = {
    nameservers = [
      "67.207.67.3"
      "67.207.67.2"
    ];
    defaultGateway = "167.99.64.1";
    defaultGateway6 = {
      address = "";
      interface = "eth0";
    };
    dhcpcd.enable = false;
    usePredictableInterfaceNames = lib.mkForce false;

    interfaces = {
      eth0 = {
        ipv4.addresses = [
          {
            address = "167.99.73.196";
            prefixLength = 20;
          }
          {
            address = "10.15.0.6";
            prefixLength = 16;
          }
        ];
        ipv6.addresses = [
          {
            address = "fe80::7c19:82ff:fe1c:d0bd";
            prefixLength = 64;
          }
        ];
        ipv4.routes = [{
          address = "167.99.64.1";
          prefixLength = 32;
        }];
        ipv6.routes = [{
          address = "";
          prefixLength = 128;
        }];
      };
      eth1 = {
        ipv4.addresses = [
          {
            address = "10.130.0.3";
            prefixLength = 16;
          }
        ];
        ipv6.addresses = [
          {
            address = "fe80::98c0:77ff:fe62:439b";
            prefixLength = 64;
          }
        ];
      };
    };
  };

  services.udev.extraRules = ''
    ATTR{address}=="7e:19:82:1c:d0:bd", NAME="eth0"
    ATTR{address}=="9a:c0:77:62:43:9b", NAME="eth1"
  '';
}
