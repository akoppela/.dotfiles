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
    nix.settings.trusted-users = [ userName ];

    nixpkgs.overlays = [
      (import ../../overlay/pkgs.nix)
    ];

    # Allowed unfree packages
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "1password"
      "slack"
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

    # Enable Docker
    virtualisation.docker.enable = true;

    # Set user
    users.users."${userName}" = {
      isNormalUser = true;
      extraGroups = [ "wheel" "audio" "docker" ];
    };
    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;

      users."${userName}" = hmModule: {
        # This value determines the Home Manager release that your
        # configuration is compatible with. This helps avoid breakage
        # when a new Home Manager release introduces backwards
        # incompatible changes.
        #
        # You can update Home Manager without changing this value. See
        # the Home Manager release notes for a list of state version
        # changes in each release.
        home.stateVersion = "18.09";

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
          pkgs.htop # Monitoring
          pkgs.bluez # Bluetooth
          pkgs.pavucontrol # Audio
          pkgs.killall # Process utility

          # Development
          pkgs.vim
          pkgs.tokei
          pkgs.ripgrep

          # Tools
          pkgs.unzip
          pkgs.gcc

          # Security
          pkgs._1password-gui
          pkgs.pinentry-gtk2

          # Communication
          pkgs.slack
          pkgs.zoom-us
        ];

        home.activation.linkEmacsConfig = hmModule.lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          if [ ! -e $HOME/.emacs.d ]; then
            $DRY_RUN_CMD ln -s $HOME/.dotfiles/emacs $HOME/.emacs.d
          fi
        '';
        programs.emacs = {
          enable = true;
          package = pkgs.emacs;
        };

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
          historyFile = "$HOME/.config/bash/history";
          initExtra = ''
            [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
          '';
        };

        programs.chromium.enable = true;

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
