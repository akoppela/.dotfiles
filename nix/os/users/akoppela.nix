{ config, pkgs, lib, ... }:

let
  userName = "akoppela";
  userFont = "Iosevka Term";

  emacs = pkgs.emacsWithPackages (epkgs: [
    epkgs.vterm
  ]);
in
{
  imports = [
    <home-manager/nixos>
  ];

  config = {
    nix.trustedUsers = [ userName ];

    nixpkgs.overlays = [
      (import ../../overlay/pkgs.nix)
    ];


    # Enable graphical interface
    services.xserver = lib.mkIf config.services.xserver.enable {
      xkbOptions = "caps:swapescape";
      libinput.enable = true;
      libinput.touchpad.naturalScrolling = true;
      displayManager.startx.enable = true;
      serverFlagsSection = ''
        Option "DontVTSwitch" "True"
      '';
    };

    # Enable screen locker
    programs.slock.enable = true;
    systemd.services.my-sleep-locker = {
      description = "Locks the screen on sleep";
      before = [ "sleep.target" ];
      wantedBy = [ "sleep.target" ];
      script = "${config.security.wrapperDir}/slock";
      serviceConfig = {
        User = userName;
      };
      environment = {
        DISPLAY = ":${toString config.services.xserver.display}";
      };
    };

    users.users."${userName}" = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };

    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;

      users.akoppela = hmModule: {
        home.sessionVariables = {
          EDITOR = "${emacs}/bin/emacs";
          SHELL = "${pkgs.bashInteractive}/bin/bash";
          MY_FONT = userFont;
        };

        home.packages = [
          # Text
          (pkgs.aspellWithDicts (dict: [
            dict.en
            dict.en-computers
            dict.en-science
          ]))
          pkgs.vim
          pkgs.ripgrep

          # Fonts
          pkgs.iosevka-term

          # System
          pkgs.brightnessctl # Brightness
          pkgs.scrot # Screenshots
          pkgs.bottom # Monitoring

        ];

        programs.emacs = {
          enable = true;
          package = emacs;
        };
        home.activation.linkEmacsConfig = hmModule.lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          if [ ! -e $HOME/.emacs.d ]; then
            $DRY_RUN_CMD ln -s $HOME/.dotfiles/emacs $HOME/.emacs.d
          fi
        '';

        programs.git = {
          enable = true;
          userName = "akoppela";
          userEmail = "akoppela@gmail.com";
        };

        programs.direnv = {
          enable = true;
          nix-direnv.enable = true;
          nix-direnv.enableFlakes = true;
          enableBashIntegration = true;
        };

        programs.bash = {
          enable = true;
          initExtra = "[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx ${emacs}/bin/emacs -mm --debug-init";
        };

        programs.firefox = {
          enable = true;
        };

        programs.kitty = {
          enable = true;
          font = {
            name = userFont;
            size = 19;
          };
          settings = {
            # Font
            bold_font = "${userFont} Bold";
            italic_font = "${userFont} Italic";
            bold_italic_font = "${userFont} Bold Italic";
            disable_ligatures = "always";

            # Mouse
            mouse_hide_wait = "-1.0";

            # Bell
            enable_audio_bell = "no";

            # Color scheme
            background = "#1c1c1c";
            background_opacity = "1.0";

            # OS specific
            macos_option_as_alt = "yes";
            macos_thicken_font = "0.2";
          };
        };
      };
    };
  };
}
