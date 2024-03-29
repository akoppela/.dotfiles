{ config, ... }:

{
  # Include acpi_call for battery recalibrations
  boot.kernelModules = [ "acpi_call" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.acpi_call ];

  services.power-profiles-daemon.enable = false;

  powerManagement.enable = true;
  powerManagement.powertop.enable = true;

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      START_CHARGE_THRESH_BAT0 = "84";
      STOP_CHARGE_THRESH_BAT0 = "90";
    };
  };
}
