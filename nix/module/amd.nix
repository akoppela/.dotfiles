{ pkgs, ... }:

{
  boot.kernelModules = [ "kvm-amd" ];
  boot.initrd.kernelModules = [ "amdgpu" ];

  services.xserver.videoDrivers = [ "amdgpu" ];

  hardware.cpu.amd.updateMicrocode = true;

  hardware.opengl.extraPackages = [ pkgs.amdvlk ];
}
