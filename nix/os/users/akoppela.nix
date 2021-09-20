{ pkgs, ... }:

{
  imports = [
    <home-manager/nixos>
  ];

  users.users.akoppela = {
    password = "123";
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

    users.akoppela = { pkgs, lib, ... }: {
      home.packages = [
        # Text
        (pkgs.aspellWithDicts (dict: [
          dict.en
          dict.en-computers
          dict.en-science
        ]))
        pkgs.ripgrep
        pkgs.vim
      ];

      programs.emacs = {
        enable = true;
        package = pkgs.emacs-nox;
        extraPackages = epkgs: [
          epkgs.vterm
        ];
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
        enableBashIntegration = true;
      };

      programs.bash = {
        enable = true;
      };
    };
  };
}