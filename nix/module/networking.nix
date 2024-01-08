{
  # Enable Firewall
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ ];
    allowedUDPPorts = [ ];
  };

  # Enable SSH with agent and Mosh
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };
  programs.ssh.startAgent = true;
  programs.mosh.enable = true;

  # Set DNS
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];
}
