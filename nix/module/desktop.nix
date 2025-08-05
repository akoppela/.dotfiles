{ pkgs, lib, ... }:

{
  services.dbus.enable = true;

  xdg.portal.enable = true;
  xdg.portal.extraPortals = lib.mkForce [
    pkgs.xdg-desktop-portal-gnome
  ];

  services.xserver = {
    enable = true;
    autoRepeatDelay = 350;
    autoRepeatInterval = 25;
    xkb = {
      layout = "us,ru";
      options = "caps:swapescape,grp:win_space_toggle";
    };
    displayManager.startx.enable = true;
  };

  services.libinput = {
    enable = true;
    touchpad.naturalScrolling = true;
    touchpad.clickMethod = "clickfinger";
  };

  services.xserver.desktopManager.gnome.enable = true;
  environment.gnome.excludePackages = [
    pkgs.gnome-photos
    pkgs.gnome-tour
    pkgs.gnome-secrets
    pkgs.gnome-builder
    pkgs.gnome-text-editor
    pkgs.gnome-connections
    pkgs.gnome-user-docs
    pkgs.gnome-terminal
    pkgs.gnome-calculator
    pkgs.gnome-calendar
    pkgs.gnome-characters
    pkgs.gnome-clocks
    pkgs.gnome-contacts
    pkgs.gnome-maps
    pkgs.gnome-weather
    pkgs.gnome-notes
    pkgs.gnome-font-viewer
    pkgs.seahorse
    pkgs.epiphany
    pkgs.totem
    pkgs.geary
    pkgs.yelp
    pkgs.cheese
  ];
}
