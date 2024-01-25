{
  boot.kernelModules = [ "kvm-amd" ];
  boot.initrd.kernelModules = [ "amdgpu" ];

  hardware.cpu.amd.updateMicrocode = true;
}
