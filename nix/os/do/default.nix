{ lib, ... }:

{
  imports =
    [ ../default.nix
      ./config/hardware.nix
      ./config/networking.nix
    ];

  # Enable default DO networking
  networking.networking.do.enable = true;
}
