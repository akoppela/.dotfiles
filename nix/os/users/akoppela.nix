{ config, pkgs, lib, ... }:

let
  userName = "akoppela";
  userFont = "Iosevka Term";
  xEnabled = config.services.xserver.enable;

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
    console.useXkbConfig = true;
    services.xserver = lib.mkIf xEnabled {
      xkbOptions = "caps:swapescape";
      libinput.enable = true;
      libinput.touchpad.naturalScrolling = true;
      displayManager.lightdm.enable = true;
      windowManager.session = lib.singleton {
        name = "exwm";
        start = "${emacs}/bin/emacs -mm --debug-init";
      };
    };

    # Global environment variables
    environment.variables = {
      MY_FONT = userFont;
    };

    users.users."${userName}" = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keyFiles = [
        ../../../keys/mac-mini.pub
        ../../../keys/ipad.pub
      ];
      shell = "${pkgs.zsh}/bin/zsh";
    };

    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;

      users.akoppela = { config, lib, ... }: {
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
        home.activation.linkEmacsConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
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
          enableBashIntegration = config.programs.bash.enable;
          enableZshIntegration = config.programs.zsh.enable;
        };

        programs.zsh = {
          enable = true;
          dotDir = ".config/zsh";
          enableAutosuggestions = true;
          history = {
            expireDuplicatesFirst = true;
            extended = true;
          };
          oh-my-zsh = {
            enable = true;
            theme = "robbyrussell";
            plugins = [ ];
          };
        };

        programs.bash = {
          enable = true;
        };

        programs.firefox = {
          enable = xEnabled;
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
