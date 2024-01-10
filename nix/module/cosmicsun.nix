{ config, pkgs, lib, home-manager, ... }:

let
  userName = "cosmicsun";
in
{
  imports = [
    home-manager.nixosModules.home-manager
  ];

  config = {
    nix.settings.trusted-users = [ userName ];

    users.users."${userName}" = {
      isNormalUser = true;
      extraGroups = [ "wheel" "audio" "video" "networkmanager" ];
    };

    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;

      users."${userName}" = {
        fonts.fontconfig.enable = true;

        home.packages = [
          # Music
          pkgs.ardour
        ];

        programs.firefox.enable = true;

        # This value determines the Home Manager release that your
        # configuration is compatible with. This helps avoid breakage
        # when a new Home Manager release introduces backwards
        # incompatible changes.
        #
        # You can update Home Manager without changing this value. See
        # the Home Manager release notes for a list of state version
        # changes in each release.
        home.stateVersion = "18.09";
      };
    };
  };
}
