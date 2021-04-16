{ config, pkgs, lib, ... }:
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

  services.nix-daemon.enable = true;
  users.nix.configureBuildUsers = true;

  nix.nixPath = lib.mkForce [
    { darwin-config = "$HOME/.dotfiles/nix/darwin.nix"; }
    "$HOME/.nix-defexpr/channels"
  ];

  nix.distributedBuilds = true;
  nix.buildMachines = [{
    hostName = "nix-docker";
    systems = [ "x86_64-linux" ];
    maxJobs = 4;
  }];

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

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Windor manager
  services.yabai = {
    enable = true;
    package = pkgs.yabai;
    enableScriptingAddition = false;
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
      yabai -m rule --add app='kitty' space=^1
      yabai -m rule --add app='Mail' space=^2
      yabai -m rule --add app='Telegram' space=^2
      yabai -m rule --add app='Finder' space=^3
      yabai -m rule --add app='TotalMix' space=^4 manage=off
      yabai -m rule --add app='Podcasts' space=^5
      yabai -m rule --add app='Music' space=^6
    '';
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "1password"
    ];

  users.users.akoppela.home = "/Users/akoppela";

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
        pkgs.slack-term

        # Networking
        pkgs.openvpn
        pkgs.transmission
        pkgs.mosh

        # Keyboard
        pkgs.chrysalis

        # Security
        pkgs._1password
        pkgs.gnupg
        pkgs.pinentry

        # Development
        pkgs.docker
        pkgs.docker-machine
        pkgs.nixpkgs-fmt
        pkgs.tokei

        # Gaming
        pkgs.steam

        # Audio
        pkgs.xld
        pkgs.extempore

        # Video
        pkgs.vlc

        # System
        pkgs.app-zapper
        pkgs.htop

        # Finance
        pkgs.ledger
      ];

      home.sessionVariables = {
        EDITOR = "emacs";
        SHELL = "${pkgs.zsh}/bin/zsh";
      };

      programs.bash = {
        enable = enableBash;
      };

      programs.zsh = {
        enable = enableZsh;
      };

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
        enableNixDirenvIntegration = true;
        enableBashIntegration = enableBash;
        enableZshIntegration = enableZsh;
        enableFishIntegration = enableFish;
      };

      programs.firefox = {
        enable = true;
        package = pkgs.firefox;
      };

      programs.kitty = {
        enable = true;
        font = {
          package = pkgs.jetbrains-mono;
          name = "JetBrains Mono";
          size = 12;
        };
        settings = {
          # Font
          bold_font = "JetBrains Mono Bold";
          italic_font = "JetBrains Mono Italic";
          bold_italic_font = "JetBrains Mono Bold Italic";

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

  # Used for backwards compatibility, please read the changelog before changing.
  system.stateVersion = 4;
}
