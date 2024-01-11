{ config, pkgs, lib, home-manager, ... }:

let
  userName = "cosmicsun";
in
{
  imports = [
    home-manager.nixosModules.home-manager
  ];

  config = {
    users.users."${userName}" = {
      isNormalUser = true;
      extraGroups = [ "wheel" "audio" "video" "networkmanager" ];
    };

    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;

      users."${userName}" = {
        home.sessionVariables = {
          XDG_SESSION_TYPE = "wayland";
          QT_QPA_PLATFORM = "wayland";
          MOZ_ENABLE_WAYLAND = "1";
          NIXOS_OZONE_WL = "1";
        };

        fonts.fontconfig.enable = true;

        home.packages = [
          # System
          pkgs.gnome-firmware
          pkgs.gnome.gnome-session
          pkgs.gnome.gnome-tweaks

          # Security
          pkgs._1password-gui

          # Music
          pkgs.ardour

          # Communication
          pkgs.telegram-desktop
          pkgs.zoom-us
        ];

        programs.bash = {
          enable = true;
          historyControl = [ "ignoredups" ];
          historyFile = "$HOME/.config/bash/history";
          initExtra = ''
            # Start sway from second terminal
            [[ -z $WAYLAND_DISPLAY && $XDG_VTNR -eq 2 ]] && dbus-run-session gnome-session
          '';
        };

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
