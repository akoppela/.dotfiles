{ config, pkgs, lib, ... }:

{
  imports = [
    ./do-hardware-configuration.nix
    ./wireguard.nix
    <home-manager/nixos>
  ];

  nix.nixPath = [
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    "nixos-config=/home/akoppela/.dotfiles/nix/nixos.nix"
    "/nix/var/nix/profiles/per-user/root/channels"
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/vda";

  networking.hostName = "nixos";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  networking.useDHCP = false;
  networking.interfaces.ens3.useDHCP = true;
  networking.interfaces.ens4.useDHCP = true;

  console.keyMap = "us";
  i18n.defaultLocale = "en_US.UTF-8";

  time.timeZone = "Europe/Amsterdam";

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
  };
  programs.mosh.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ ];
    allowedUDPPorts = [ ];
  };

  users.users.akoppela = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.bashInteractive;
    openssh.authorizedKeys.keyFiles = [
      ../keys/mac-mini.pub
      ../keys/ipad.pub
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

        # Networking
        pkgs.wireguard
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

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "20.03";
}
