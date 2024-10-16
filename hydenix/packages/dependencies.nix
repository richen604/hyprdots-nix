{ pkgs, ... }:
let
  fonts = import ../sources/hyde-fonts.nix { inherit pkgs; };
in
{
  home.packages = with pkgs; [
    # --------------------------------------------------- // Dependencies
    polkit_gnome # authentication agent
    xdg-desktop-portal-hyprland # xdg desktop portal for hyprland
    xdg-desktop-portal-gtk # xdg desktop portal using gtk
    # TODO: build python-pyamdgpuinfo from https://github.com/mark9064/pyamdgpuinfo
    # python-pyamdgpuinfo # for amd gpu info
    parallel # for parallel processing
    jq # for json processing
    imagemagick # for image processing
    libsForQt5.qtimageformats # for dolphin image thumbnails
    libsForQt5.ffmpegthumbs # for dolphin video thumbnails
    libsForQt5.kde-cli-tools # for dolphin file type defaults
    libsForQt5.kdegraphics-thumbnailers # for dolphin video thumbnails
    libsForQt5.kimageformats # for dolphin image thumbnails
    libsForQt5.qtwayland # for wayland support
    libsForQt5.qtsvg # for svg thumbnails
    libsForQt5.kio # for fuse support
    libsForQt5.kio-extras # for extra protocol support
    libsForQt5.kwayland # for wayland support
    resvg # for svg thumbnails
    libnotify # for notifications
    emote # emoji picker gtk3
    flatpak # package manager for flathub
    envsubst # for environment variables
    killall # for killing processes
    wl-clipboard # clipboard for wayland
    gnumake # for building hyde
    hyprcursor # cursor theme
    hyprutils # for hyprland utils
    fonts # hyde fonts

    # TODO: check these packages if they are even needed 
    xdg-utils # for xdg-open
  ];
}
