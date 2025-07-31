{ lib, ... }: {
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ ];
    allowedUDPPorts = [ ];
  };

  programs.ssh.startAgent = true;
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = lib.mkDefault "no";
    };
  };

  programs.mosh.enable = true;

  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];
}
