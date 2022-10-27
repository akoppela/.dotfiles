{
  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot/efi";
  };
  boot.loader.grub = {
    enable = true;
    version = 2;
    efiSupport = true;
    devices = [ "nodev" ];
    useOSProber = true;
  };
}
