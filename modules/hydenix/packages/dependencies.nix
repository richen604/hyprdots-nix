{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # --------------------------------------------------- // Dependencies
    polkit_gnome # authentication agent
    xdg-desktop-portal-hyprland # xdg desktop portal for hyprland
    # TODO: build python-pyamdgpuinfo from https://github.com/mark9064/pyamdgpuinfo
    # python-pyamdgpuinfo # for amd gpu info
    parallel # for parallel processing
    jq # for json processing
    imagemagick # for image processing
    kdePackages.qtimageformats # for dolphin image thumbnails
    kdePackages.ffmpegthumbs # for dolphin video thumbnails
    kdePackages.kde-cli-tools # for dolphin file type defaults
    libnotify # for notifications
    kdePackages.wayland # for wayland support
    xdg-desktop-portal-gtk # xdg desktop portal using gtk
    emote # emoji picker gtk3
    flatpak # package manager for flathub
    envsubst # for environment variables
    killall # for killing processes
    wl-clipboard # clipboard for wayland
    gnumake # for building hyde
  ];
}
