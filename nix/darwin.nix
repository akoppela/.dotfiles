{ config, pkgs, ... }:

{
  imports = [ <home-manager/nix-darwin> ];

  # Use a custom configuration.nix location.
  environment.darwinConfig = "$HOME/.dotfiles/nix/darwin.nix";

  # Allow proprietary packages
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
    "slack"
    "vscode"
  ];

  # Overlays
  nixpkgs.overlays = [
    (import ./overlay/apps.nix)
  ];

  # Temporary fix to put user apps to ~/Applications
  system.build.applications = pkgs.lib.mkForce (pkgs.buildEnv {
    name = "applications";
    paths = config.environment.systemPackages ++ config.home-manager.users.akoppela.home.packages;
    pathsToLink = "/Applications";
  });

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;

  # Home manager
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;

    users.akoppela = { pkgs, ... }: {
      # User packages
      home.packages = with pkgs; [
        ripgrep
        slack
        firefox
        alfred
        openvpn
        chrysalis
        # nodejs
      ];

      # Emacs
      programs.emacs.enable = true;
      home.file.".emacs.d" = {
        recursive = true;
        source = ../emacs;
      };
      home.file.".testfile" = {
        text = "Hello";
      };

      # Git
      programs.git = {
        enable = true;
        userEmail = "akoppela@gmail.com";
        userName = "akoppela";
      };

      # VSCode
      programs.vscode.enable = true;
    };
  };

  # Used for backwards compatibility, please read the changelog before changing.
  system.stateVersion = 4;
}