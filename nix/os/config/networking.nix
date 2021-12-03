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
    passwordAuthentication = false;
  };
  programs.ssh.startAgent = true;
  programs.mosh.enable = true;
}
