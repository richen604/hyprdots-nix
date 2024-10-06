{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # --------------------------------------------------- // Display Manager
    kdePackages.sddm # display manager for KDE plasma
    libsForQt5.qt5.qtquickcontrols # for sddm theme ui elements
    libsForQt5.qt5.qtquickcontrols2 # for sddm theme ui elements
    libsForQt5.qt5.qtgraphicaleffects # for sddm theme effects
    kdePackages.qtsvg # for sddm theme svg icons
    libsForQt5.qt5.qtwayland # wayland support for qt5
    qt6.qtwayland # wayland support for qt6
    qtcreator # qt ide
    qt6.qmake # qt6 build system
  ];
}
