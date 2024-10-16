{ config, pkgs, lib, home-manager, ... }:

let
  userName = "cosmicsun";
in
{
  imports = [
    home-manager.nixosModules.home-manager
  ];

  config = {
    programs.slock.enable = true;
    systemd.services."${userName}-sleep-locker" = {
      description = "Locks the screen on sleep";
      before = [ "sleep.target" ];
      wantedBy = [ "sleep.target" ];
      script = "${config.security.wrapperDir}/slock";
      serviceConfig = {
        User = userName;
      };
      environment = {
        DISPLAY = ":1";
      };
    };

    users.users."${userName}" = {
      isNormalUser = true;
      extraGroups = [ "wheel" "audio" "video" "networkmanager" ];
    };

    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;

      users."${userName}" = {
        home.sessionVariables = {
          XDG_SESSION_TYPE = "x11";
          GDK_BACKEND = "x11";

          LV2_PATH = "/etc/profiles/per-user/${userName}/lib/lv2";
          LADSPA_PATH = "/etc/profiles/per-user/${userName}/lib/ladspa";
        };

        home.file.".xinitrc".text = ''
          xrandr --output eDP-1 --primary --mode 1920x1200 --pos 0x0 --rotate normal
          exec gnome-session
        '';

        fonts.fontconfig.enable = true;

        dconf.enable = true;
        dconf.settings = {
          "org/gnome/desktop/interface".color-scheme = "prefer-dark";

          "org/gnome/settings-daemon/plugins/media-keys".custom-keybindings = [
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
          ];

          "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
            name = "Switch to Emacs";
            binding = "<Control>Tab";
            command = "pkexec chvt 1";
          };
        };

        home.packages = [
          # System
          pkgs.gnome-firmware
          pkgs.gnome.gnome-session
          pkgs.gnome.gnome-tweaks

          # Security
          pkgs._1password-gui

          # Music
          pkgs.ardour
          pkgs.audacity
          pkgs.helm
          pkgs.surge-XT
          pkgs.lsp-plugins
          pkgs.x42-plugins
          pkgs.dragonfly-reverb
          pkgs.roomeqwizard

          # Video
          pkgs.vlc
          pkgs.obs-studio

          # Communication
          pkgs.telegram-desktop
          pkgs.zoom-us
        ];

        programs.bash = {
          enable = true;
          historyControl = [ "ignoredups" ];
          historyFile = "$HOME/.config/bash/history";
          initExtra = ''
            # Logout from TTY after 3 minutes
            [[ $(tty) =~ /dev\/tty[1-6] ]] && TMOUT=180

            # Start X from second terminal
            [[ -z $DISPLAY && $XDG_VTNR -eq 2 ]] && exec startx
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
