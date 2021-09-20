{
  # Enable Firewall
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ ];
    allowedUDPPorts = [ ];
  };

  # Enable SSH ans Mosh
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
  };
  programs.mosh.enable = true;
}
