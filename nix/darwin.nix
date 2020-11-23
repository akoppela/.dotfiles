{ config, pkgs, ... }:

let
  window_gap = "2";
in
{
  imports = [ <home-manager/nix-darwin> ];

  # Use a custom configuration.nix location.
  environment.darwinConfig = "$HOME/.dotfiles/nix/darwin.nix";

  # Allow proprietary packages
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
    "slack"
    "1password"
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

  # Windor manager
  services.yabai = {
    enable = true;
    package = pkgs.yabai;
    enableScriptingAddition = true;
    config = {
      # Layout
      layout = "bsp";
      auto_balance = "on";
      top_padding = window_gap;
      bottom_padding = window_gap;
      left_padding = window_gap;
      right_padding = window_gap;
      window_gap = window_gap;
      external_bar = "all:0:0";
      split_ratio = 0.5;

      # Window
      window_placement = "second_child";
      window_topmost = "on";
      window_shadow = "on";
    };
    extraConfig = ''
      # Rules
      yabai -m rule --add app='System Preferences' manage=off
      yabai -m rule --add app='Safari' space=^1
      yabai -m rule --add app='Emacs' space=^1
      yabai -m rule --add app='Podcasts' space=^2
      yabai -m rule --add app='Mail' space=^3
      yabai -m rule --add app='Slack' space=^3
      yabai -m rule --add app='Finder' space=^4
    '';
  };

  # Home manager
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;

    users.akoppela = { pkgs, ... }: {
      # User packages
      home.packages = with pkgs; [
        # Text
        ripgrep
        jq

        # Communication
        slack

        # Networking
        openvpn
        firefox

        # Productivity
        alfred

        # System
        htop

        # Keyboard
        chrysalis

        # Security
        _1password
      ];

      # Emacs
      programs.emacs.enable = true;
      home.file.".emacs.d" = {
        recursive = true;
        source = ../emacs;
      };

      # Git
      programs.git = {
        enable = true;
        userEmail = "akoppela@gmail.com";
        userName = "akoppela";
      };
    };
  };

  # Used for backwards compatibility, please read the changelog before changing.
  system.stateVersion = 4;
}