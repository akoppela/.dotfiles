{ config, pkgs, ... }:
let
  window_gap = "2";
  enableBash = true;
  enableZsh = true;
  enableFish = false;
in
{
  imports = [
    <home-manager/nix-darwin>
  ];

  environment.darwinConfig = "$HOME/.dotfiles/nix/darwin.nix";

  nix.trustedUsers = [
    "root"
    "akoppela"
  ];

  nixpkgs.overlays = [
    (import ./overlay/apps.nix)
    (import ./overlay/pkgs.nix)
  ];

  # Temporary fix to count user apps from home-manager as well
  system.build.applications = pkgs.lib.mkForce (pkgs.buildEnv {
    name = "applications";
    paths = config.environment.systemPackages ++ config.home-manager.users.akoppela.home.packages;
    pathsToLink = "/Applications";
  });
  # Temporary fix to copy all the apps so that spotlight can find them
  system.activationScripts.applications.text = pkgs.lib.mkForce (
    ''
      echo "setting up ~/Applications/Nix Apps..."
      rm -rf $HOME/Applications/Nix\ Apps
      mkdir -p $HOME/Applications/Nix\ Apps
      find ${config.system.build.applications}/Applications -maxdepth 1 -type l | while read app; do
        src="$(/usr/bin/stat -f%Y "$app")"
        cp -r "$src" $HOME/Applications/Nix\ Apps
      done
    ''
  );

  system.defaults = {
    ".GlobalPreferences"."com.apple.sound.beep.sound" = "/System/Library/Sounds/Submarine.aiff";
    NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false;
  };

  system.activationScripts.extraUserActivation.text = ''
    echo >&2 "extra user defaults..."

    defaults write com.apple.Safari WebContinuousSpellCheckingEnabled -bool true
    defaults write com.apple.Safari WebAutomaticSpellingCorrectionEnabled -bool false
  '';

  programs.bash.enable = enableBash;
  programs.zsh.enable = enableZsh;
  programs.fish.enable = enableFish;
  environment.shells = [
    pkgs.bash
    pkgs.zsh
  ];
  environment.interactiveShellInit = ''
    source "$HOME/.secrets"
  '';

  # Windor manager
  services.yabai = {
    enable = true;
    package = pkgs.yabai;
    enableScriptingAddition = true;
    config = {
      layout = "bsp";
      auto_balance = "on";
      top_padding = window_gap;
      bottom_padding = window_gap;
      left_padding = window_gap;
      right_padding = window_gap;
      window_gap = window_gap;
      external_bar = "all:0:0";
      split_ratio = 0.5;
      window_placement = "second_child";
      window_topmost = "on";
      window_shadow = "on";
    };
    extraConfig = ''
      # Rules
      yabai -m rule --add app='System Preferences' manage=off
      yabai -m rule --add app='Safari' space=^1
      yabai -m rule --add app='Emacs' space=^1
      yabai -m rule --add app='Firefox' space=^1
      yabai -m rule --add app='Mail' space=^2
      yabai -m rule --add app='Slack' space=^2
      yabai -m rule --add app='Telegram' space=^2
      yabai -m rule --add app='Finder' space=^3
      yabai -m rule --add app='TotalMix' space=^4 manage=off
      yabai -m rule --add app='Podcasts' space=^5
      yabai -m rule --add app='Music' space=^6
    '';
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "slack"
      "1password"
    ];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;

    users.akoppela = { pkgs, ... }: {
      home.packages = [
        # Text
        (pkgs.aspellWithDicts (dict: [
          dict.en
          dict.en-computers
          dict.en-science
        ]))
        pkgs.ripgrep
        pkgs.jq

        # Communication
        pkgs.slack
        pkgs.telegram

        # Networking
        pkgs.openvpn
        pkgs.transmission

        # Productivity
        pkgs.alfred

        # Keyboard
        pkgs.chrysalis

        # Security
        pkgs._1password
        pkgs.gnupg

        # Development
        pkgs.docker
        pkgs.docker-machine
        pkgs.nixpkgs-fmt

        # Gaming
        pkgs.steam

        # Audio
        pkgs.xld
        pkgs.extempore
      ];

      home.sessionVariables = {
        EDITOR = "emacs";
        SHELL = pkgs.zsh;
      };

      programs.bash = {
        enable = enableBash;
      };

      programs.zsh = {
        enable = enableZsh;
      };

      programs.emacs = {
        enable = true;
        package = pkgs.emacsMacport;
        extraPackages = epkgs: [
          epkgs.vterm
        ];
      };
      home.file.".emacs.d" = {
        recursive = true;
        source = ../emacs;
      };

      programs.git = {
        enable = true;
        userEmail = "akoppela@gmail.com";
        userName = "akoppela";
      };

      programs.direnv = {
        enable = true;
        enableNixDirenvIntegration = true;
        enableBashIntegration = enableBash;
        enableZshIntegration = enableZsh;
        enableFishIntegration = enableFish;
      };

      programs.htop = {
        enable = true;
      };

      programs.firefox = {
        enable = true;
        package = pkgs.firefox;
      };
    };
  };

  # Used for backwards compatibility, please read the changelog before changing.
  system.stateVersion = 4;
}
