{ config, pkgs, pkgsUnstable, lib, home-manager, ... }:

let
  userName = "akoppela";
  userEmail = "akoppela@gmail.com";
  realName = "Andrey Koppel (${userName})";
  userFont = "PragmataPro Mono";
in
{
  imports = [
    home-manager.nixosModules.home-manager
  ];

  config = {
    nix.settings.trusted-users = [ userName ];

    nixpkgs.overlays = [
      (import ../overlay/pkgs.nix)
    ];

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
        DISPLAY = ":0";
      };
    };

    users.users."${userName}" = {
      isNormalUser = true;
      extraGroups = [ "wheel" "audio" "docker" "networkmanager" ];
    };

    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;

      users."${userName}" = {
        home.sessionVariables = {
          EDITOR = "${pkgs.emacs}/bin/emacs";
          SHELL = "${pkgs.bashInteractive}/bin/bash";
          MY_FONT = userFont;
          MY_MU4E_PATH = "${pkgs.mu.mu4e}/share/emacs/site-lisp/mu4e";
          XDG_SESSION_TYPE = "x11";
          GDK_BACKEND = "x11";
        };

        home.file.".xinitrc".text = ''
          xrandr --output eDP-1 --primary --mode 1920x1200 --pos 0x0 --rotate normal
          ${pkgs.emacs}/bin/emacs -mm --debug-init
        '';

        fonts.fontconfig.enable = true;

        home.packages = [
          # Text
          (pkgs.aspellWithDicts (dict: [
            dict.en
            dict.en-computers
          ]))
          pkgs.wordnet
          pkgs.texlive.combined.scheme-full

          # Fonts
          pkgs.pragmatapro

          # System
          pkgs.brightnessctl
          pkgs.scrot
          pkgs.bluez
          pkgs.alsa-utils

          # Networking
          pkgs.transmission_4
          pkgs.mosh

          # Development
          pkgs.gcc
          pkgs.vim
          pkgs.tokei
          pkgs.ripgrep
          pkgsUnstable.gpt4all

          # Tools
          pkgs.unzip
          pkgs.htop
          pkgs.btop
          pkgs.du-dust
          pkgs.killall
          pkgs.neofetch
          pkgs.powertop

          # Security
          pkgs._1password-gui
          pkgs.pinentry-gtk2

          # Communication
          pkgs.slack
        ];

        home.activation.linkEmacsConfig = home-manager.lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          if [ ! -e $HOME/.emacs.d ]; then
            $DRY_RUN_CMD ln -s $HOME/.dotfiles/emacs $HOME/.emacs.d
          fi
        '';
        programs.emacs = {
          enable = true;
          package = pkgs.emacs;
        };

        programs.gpg.enable = true;
        services.gpg-agent.enable = true;

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
          shellAliases = {
            os-update = "sudo nixos-rebuild switch --flake ~/.dotfiles#${config.networking.hostName}";
            os-build = "nix build ~/.dotfiles#nixosConfigurations.${config.networking.hostName}.config.system.build.toplevel";
          };
          initExtra = ''
            # Logout from TTY after 3 minutes
            [[ $(tty) =~ /dev\/tty[1-6] ]] && TMOUT=180

            # Start X from first terminal
            [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
          '';
        };

        programs.chromium.enable = true;
        programs.firefox.enable = true;

        programs.mbsync.enable = true;
        programs.mu.enable = true;
        programs.mu.package = pkgs.mu;
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
