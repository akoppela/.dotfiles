{
  boot.loader.efi = {
    canTouchEfiVariables = true;
  };
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 30;
  };
}
