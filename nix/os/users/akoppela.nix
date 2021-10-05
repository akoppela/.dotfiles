{ config, pkgs, lib, ... }:

let
  userName = "akoppela";

  bashEnabled = true;
  zshEnabled = true;
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


    # Enable graphical interface
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

    users.users."${userName}" = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      shell = pkgs.bashInteractive;
      openssh.authorizedKeys.keyFiles = [
        ../../../keys/mac-mini.pub
        ../../../keys/ipad.pub
      ];
    };

    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;

      users.akoppela = { lib, ... }: {
        home.packages = [
          # Text
          (pkgs.aspellWithDicts (dict: [
            dict.en
            dict.en-computers
            dict.en-science
          ]))
          pkgs.ripgrep
          pkgs.vim

          # Desktop
          pkgs.brightnessctl # Brightness
          pkgs.scrot # Screenshots

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
          userEmail = "akoppela@gmail.com";
          userName = "akoppela";
        };

        programs.direnv = {
          enable = true;
          nix-direnv.enable = true;
          nix-direnv.enableFlakes = true;
          enableBashIntegration = bashEnabled;
          enableZshIntegration = zshEnabled;
        };

        programs.zsh = {
          enable = zshEnabled;
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
          enable = bashEnabled;
        };

        programs.firefox = {
          enable = xEnabled;
        };
      };
    };
  };
}
