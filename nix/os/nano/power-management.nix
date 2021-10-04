{ config, pkgs, ... }:

{
  # Include acpi_call for battery recalibrations
  boot.kernelModules = [ "acpi_call" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.acpi_call ];

  # Enable power management
  services.tlp.enable = true;
}
