{
  imports = [
    ../config/networking.nix
  ];

  # Enables wireless support via wpa_supplicant.
  networking.wireless.enable = true;
  networking.wireless.interfaces = [ "wlp0s20f3" ];
  networking.wireless.userControlled.enable = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  networking.useDHCP = false;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  # Enable Tailscale
  services.tailscale.enable = true;
}
