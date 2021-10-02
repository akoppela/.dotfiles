{ config, pkgs, lib, ... }:

let
  userName = "akoppela";

  cfg = config."${userName}";

  emacs = pkgs.emacsWithPackages (epkgs: [
    epkgs.vterm
  ]);

  packages = [
    # Text
    (pkgs.aspellWithDicts (dict: [
      dict.en
      dict.en-computers
      dict.en-science
    ]))
    pkgs.ripgrep
    pkgs.vim

    # Audio
    pkgs.pulsemixer
  ];

  xPackages =
    if cfg.enableX then
      [
        pkgs.firefox
      ]
    else
      [ ];
in
{
  imports = [
    <home-manager/nixos>
  ];

  options."${userName}" = {
    enableX = lib.mkEnableOption "Enable GUI";
  };

  config = {
    nix.trustedUsers = [ userName ];

    # Enable graphical interface
    services.xserver = lib.mkIf cfg.enableX {
      enable = true;
      libinput.enable = true;
      displayManager.gdm.enable = true;
      windowManager.session = lib.singleton {
        name = "exwm";
        start = "${emacs}/bin/emacs -mm";
      };
      layout = "us";
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
        home.packages = packages ++ xPackages;

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
          enableBashIntegration = true;
        };

        programs.bash = {
          enable = true;
        };
      };
    };
  };
}
