{
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    # --------------------------------------------------- // Theming
    nwg-look # gtk configuration tool
    libsForQt5.qt5ct # qt5 configuration tool
    kdePackages.qt6ct # qt6 configuration tool
    libsForQt5.qtstyleplugin-kvantum # svg based qt6 theme engine
    kdePackages.qtstyleplugin-kvantum # svg based qt5 theme engine
    gtk3 # gtk3
    gtk4 # gtk4
    glib # gtk theme management
    gsettings-desktop-schemas # gsettings schemas
    desktop-file-utils # for updating desktop database
    tela-circle-icon-theme # icon theme
    bibata-cursors # cursor theme
  ];
}
