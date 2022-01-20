{ config, pkgs, lib, ... }:

let
  userName = "akoppela";
  userEmail = "akoppela@gmail.com";
  realName = "Andrey Koppel (${userName})";
  userFont = "PragmataPro Mono";
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
      "zoom"
    ];

    # Enable graphical interface
    services.xserver = lib.mkIf config.services.xserver.enable {
      autoRepeatDelay = 350;
      autoRepeatInterval = 25;
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
      extraGroups = [ "wheel" "audio" ];
    };

    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;

      users."${userName}" = hmModule: {
        home.sessionVariables = {
          EDITOR = "${pkgs.emacs}/bin/emacs";
          SHELL = "${pkgs.bashInteractive}/bin/bash";
          MY_FONT = userFont;
          MY_MU4E_PATH = "${pkgs.mu}/share/emacs/site-lisp/mu4e";
        };

        home.file.".xinitrc".text = ''
          xrandr --output eDP-1 --primary --mode 2160x1350 --pos 0x0 --rotate normal
          ${pkgs.emacs}/bin/emacs -mm --debug-init
        '';

        fonts.fontconfig.enable = true;

        home.packages = [
          # Text
          (pkgs.aspellWithDicts (dict: [
            dict.en
            dict.en-computers
            dict.en-science
          ]))
          pkgs.wordnet
          pkgs.texlive.combined.scheme-full

          # Fonts
          pkgs.pragmatapro

          # System
          pkgs.brightnessctl # Brightness
          pkgs.scrot # Screenshots
          pkgs.bottom # Monitoring
          pkgs.bluez # Bluetooth
          pkgs.htop
          pkgs.killall

          # Tools
          pkgs.vim
          pkgs.unzip
          pkgs.ripgrep
          pkgs.gcc

          # Security
          pkgs._1password-gui
          pkgs.pinentry-gtk2

          # Communication
          pkgs.slack
          pkgs.zoom-us
        ];

        programs.emacs = {
          enable = true;
          package = pkgs.emacs;
        };
        home.activation.linkEmacsConfig = hmModule.lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          if [ ! -e $HOME/.emacs.d ]; then
            $DRY_RUN_CMD ln -s $HOME/.dotfiles/emacs $HOME/.emacs.d
          fi
        '';

        programs.gpg.enable = true;
        services.gpg-agent = {
          enable = true;
        };

        programs.git = {
          enable = true;
          userName = userName;
          userEmail = userEmail;
          extraConfig = {
            github.user = userName;
          };
        };

        programs.direnv = {
          enable = true;
          nix-direnv.enable = true;
          enableBashIntegration = true;
        };

        programs.bash = {
          enable = true;
          historyControl = [ "ignoredups" ];
          initExtra = ''
            [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
          '';
        };

        programs.chromium.enable = true;

        programs.kitty = {
          enable = true;
          font = {
            name = userFont;
            size = 17;
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
          "${userEmail}" = {
            primary = true;
            flavor = "gmail.com";
            address = userEmail;
            userName = userEmail;
            realName = realName;
            passwordCommand = "emacsclient -e '(auth-source-pick-first-password :host \"smtp.gmail.com\")' | cut -d '\"' -f2";
            mu.enable = true;
            imap.tls.enable = true;
            smtp.tls.enable = true;
            mbsync = {
              enable = true;
              groups."${userName}-gmail".channels = {
                inbox = {
                  farPattern = "INBOX";
                  nearPattern = "Inbox";
                  extraConfig = {
                    Create = "Both";
                    Expunge = "Both";
                    SyncState = "*";
                  };
                };

                sent = {
                  farPattern = "[Gmail]/Sent Mail";
                  nearPattern = "Sent";
                  extraConfig = {
                    Create = "Both";
                    Expunge = "Both";
                    SyncState = "*";
                  };
                };

                drafts = {
                  farPattern = "[Gmail]/Drafts";
                  nearPattern = "Drafts";
                  extraConfig = {
                    Create = "Both";
                    Expunge = "Both";
                    SyncState = "*";
                  };
                };

                trash = {
                  farPattern = "[Gmail]/Trash";
                  nearPattern = "Trash";
                  extraConfig = {
                    Create = "Both";
                    Expunge = "Both";
                    SyncState = "*";
                  };
                };

                spam = {
                  farPattern = "[Gmail]/Spam";
                  nearPattern = "Spam";
                  extraConfig = {
                    Create = "Both";
                    Expunge = "Both";
                    SyncState = "*";
                  };
                };

                starred = {
                  farPattern = "[Gmail]/Starred";
                  nearPattern = "Starred";
                  extraConfig = {
                    Create = "Both";
                    Expunge = "Both";
                    SyncState = "*";
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
