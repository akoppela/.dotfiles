{
  services.xserver = {
    enable = true;
    tty = 2;
    autoRepeatDelay = 350;
    autoRepeatInterval = 25;
    xkbOptions = "caps:swapescape";
    libinput.enable = true;
    libinput.touchpad.naturalScrolling = true;
    displayManager.startx.enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };
}
