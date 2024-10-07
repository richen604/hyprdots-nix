{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # --------------------------------------------------- // System
    pipewire # audio/video server
    wireplumber # pipewire session manager
    pavucontrol # pulseaudio volume control
    pamixer # pulseaudio cli mixer
    networkmanager # network manager
    networkmanagerapplet # network manager system tray utility
    bluez # bluetooth protocol stack
    bluez-tools # bluetooth utility cli
    blueman # bluetooth manager gui
    brightnessctl # screen brightness control
    udiskie # manage removable media
    swayidle # sway idle management
    playerctl # media player cli
    gobject-introspection # for python packages
    (python3.withPackages (ps: with ps; [ pygobject3 ]))
    trash-cli # cli to manage trash files
    libinput-gestures # actions touchpad gestures using libinput
    gnomeExtensions.window-gestures # gui for libinput-gestures
    lm_sensors # system sensors
    pciutils # pci utils
  ];
}
