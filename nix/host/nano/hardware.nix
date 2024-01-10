{ modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ../../module/bootloader.nix
    ../../module/intel.nix
    ../../module/ssd.nix
    ../../module/audio.nix
    ../../module/bluetooth.nix
    ../../module/power-management.nix
    ../../module/firmware.nix
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "thunderbolt"
    "nvme"
    "usb_storage"
    "sd_mod"
  ];

  boot.supportedFilesystems = [ "ntfs" ];
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  nixpkgs.hostPlatform = "x86_64-linux";
}
