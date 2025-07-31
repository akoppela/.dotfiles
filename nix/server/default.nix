{
  imports = [
    ../module/host.nix
    ../module/networking.nix
    ./hardware.nix
  ];

  # Enable in-memory swap
  zramSwap.enable = true;

  # Keep temporary directory clean
  boot.tmp.cleanOnBoot = true;

  # Default TCP ports
  networking.firewall.allowedTCPPorts = [
    22 # SSH
  ];

  # SSH keys
  users.users.root.openssh.authorizedKeys.keys = [
    (builtins.readFile ../../keys/p16s.pub)
  ];

  # Allow root login
  services.openssh.settings.PermitRootLogin = "yes";
}
