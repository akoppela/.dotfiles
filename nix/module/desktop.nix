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
    xkb.options = "caps:swapescape";
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

    pkgs.gnome.seahorse
    pkgs.gnome.gnome-terminal
    pkgs.gnome.epiphany
    pkgs.gnome.totem
    pkgs.gnome.geary
    pkgs.gnome.yelp
    pkgs.gnome.cheese
    pkgs.gnome.gnome-calculator
    pkgs.gnome.gnome-calendar
    pkgs.gnome.gnome-characters
    pkgs.gnome.gnome-clocks
    pkgs.gnome.gnome-contacts
    pkgs.gnome.gnome-maps
    pkgs.gnome.gnome-weather
    pkgs.gnome.gnome-notes
    pkgs.gnome.gnome-font-viewer
  ];
}
