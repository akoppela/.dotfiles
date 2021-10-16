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

    # Allowed unfree packages
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "1password"
      "slack"
      "steam"
      "steam-original"
      "steam-runtime"
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

    # Enable Steam for gaming
    programs.steam.enable = true;

    # Set user
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
          MY_MU4E_PATH = "${pkgs.mu}/share/emacs/site-lisp/mu4e";
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
          pkgs.bluez # Bluetooth

          # Security
          pkgs._1password-gui

          # Communication
          pkgs.slack
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
          initExtra = ''
            [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx ${emacs}/bin/emacs -mm --debug-init
          '';
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

        programs.mbsync.enable = true;
        programs.mu.enable = true;

        accounts.email.accounts = {
          akoppela = {
            primary = true;
            flavor = "gmail.com";
            address = "akoppela@gmail.com";
            userName = "akoppela@gmail.com";
            realName = "Andrey Koppel (akoppela)";
            passwordCommand = "${pkgs.coreutils}/bin/cat $HOME/.dotfiles/secret/akoppela-gmail";
            signature = {
              showSignature = "append";
              text = ''
                Thank you,
                Andrey.
              '';
            };
            mbsync = {
              enable = true;
              create = "both";
            };
            mu.enable = true;
            imap.tls.enable = true;
            smtp.tls.enable = true;
          };
        };
      };
    };
  };
}
