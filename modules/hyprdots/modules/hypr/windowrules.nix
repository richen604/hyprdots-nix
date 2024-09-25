{
  # █░█░█ █ █▄░█ █▀▄ █▀█ █░█░█   █▀█ █░█ █░░ █▀▀ █▀
  # ▀▄▀▄▀ █ █░▀█ █▄▀ █▄█ ▀▄▀▄▀   █▀▄ █▄█ █▄▄ ██▄ ▄█

  # See https://wiki.hyprland.org/Configuring/Window-Rules/

  windowrule = [
    "opacity 0.90 0.90,^(firefox)$"
    "opacity 0.90 0.90,^(Brave-browser)$"
    "opacity 0.80 0.80,^(code-oss)$"
    "opacity 0.80 0.80,^(Code)$"
    "opacity 0.80 0.80,^(code-url-handler)$"
    "opacity 0.80 0.80,^(code-insiders-url-handler)$"
    "opacity 0.80 0.80,^(kitty)$"
    "opacity 0.80 0.80,^(org.kde.dolphin)$"
    "opacity 0.80 0.80,^(org.kde.ark)$"
    "opacity 0.80 0.80,^(nwg-look)$"
    "opacity 0.80 0.80,^(qt5ct)$"
    "opacity 0.80 0.80,^(qt6ct)$"
    "opacity 0.80 0.80,^(kvantummanager)$"
    "opacity 0.80 0.70,^(org.pulseaudio.pavucontrol)$"
    "opacity 0.80 0.70,^(blueman-manager)$"
    "opacity 0.80 0.70,^(nm-applet)$"
    "opacity 0.80 0.70,^(nm-connection-editor)$"
    "opacity 0.80 0.70,^(org.kde.polkit-kde-authentication-agent-1)$"
    "opacity 0.80 0.70,^(polkit-gnome-authentication-agent-1)$"
    "opacity 0.80 0.70,^(org.freedesktop.impl.portal.desktop.gtk)$"
    "opacity 0.80 0.70,^(org.freedesktop.impl.portal.desktop.hyprland)$"
    "opacity 0.70 0.70,^([Ss]team)$"
    "opacity 0.70 0.70,^(steamwebhelper)$"
    "opacity 0.70 0.70,^(Spotify)$"
    "opacity 0.70 0.70,title:^(Spotify Free)$"
    "opacity 0.70 0.70,title:^(Spotify Premium)$"

    "opacity 0.90 0.90,^(com.github.rafostar.Clapper)$" # Clapper-Gtk
    "opacity 0.80 0.80,^(com.github.tchx84.Flatseal)$" # Flatseal-Gtk
    "opacity 0.80 0.80,^(hu.kramo.Cartridges)$" # Cartridges-Gtk
    "opacity 0.80 0.80,^(com.obsproject.Studio)$" # Obs-Qt
    "opacity 0.80 0.80,^(gnome-boxes)$" # Boxes-Gtk
    "opacity 0.80 0.80,^(vesktop)$" # Vesktop
    "opacity 0.80 0.80,^(discord)$" # Discord-Electron
    "opacity 0.80 0.80,^(WebCord)$" # WebCord-Electron
    "opacity 0.80 0.80,^(ArmCord)$" # ArmCord-Electron
    "opacity 0.80 0.80,^(app.drey.Warp)$" # Warp-Gtk
    "opacity 0.80 0.80,^(net.davidotek.pupgui2)$" # ProtonUp-Qt
    "opacity 0.80 0.80,^(yad)$" # Protontricks-Gtk
    "opacity 0.80 0.80,^(Signal)$" # Signal-Gtk
    "opacity 0.80 0.80,^(io.github.alainm23.planify)$" # planify-Gtk
    "opacity 0.80 0.80,^(io.gitlab.theevilskeleton.Upscaler)$" # Upscaler-Gtk
    "opacity 0.80 0.80,^(com.github.unrud.VideoDownloader)$" # VideoDownloader-Gtk
    "opacity 0.80 0.80,^(io.gitlab.adhami3310.Impression)$" # Impression-Gtk
    "opacity 0.80 0.80,^(io.missioncenter.MissionCenter)$" # MissionCenter-Gtk
    "opacity 0.80 0.80,^(io.github.flattool.Warehouse)$" # Warehouse-Gtk

    "float,class:^(org.kde.dolphin)$,title:^(Progress Dialog — Dolphin)$"
    "float,class:^(org.kde.dolphin)$,title:^(Copying — Dolphin)$"
    "float,title:^(About Mozilla Firefox)$"
    "float,class:^(firefox)$,title:^(Picture-in-Picture)$"
    "float,class:^(firefox)$,title:^(Library)$"
    "float,class:^(kitty)$,title:^(top)$"
    "float,class:^(kitty)$,title:^(btop)$"
    "float,class:^(kitty)$,title:^(htop)$"
    "float,class:^(vlc)$"
    "float,class:^(kvantummanager)$"
    "float,class:^(qt5ct)$"
    "float,class:^(qt6ct)$"
    "float,class:^(nwg-look)$"
    "float,class:^(org.kde.ark)$"
    "float,class:^(org.pulseaudio.pavucontrol)$"
    "float,class:^(blueman-manager)$"
    "float,class:^(nm-applet)$"
    "float,class:^(nm-connection-editor)$"
    "float,class:^(org.kde.polkit-kde-authentication-agent-1)$"

    "float,class:^(Signal)$" # Signal-Gtk
    "float,class:^(com.github.rafostar.Clapper)$" # Clapper-Gtk
    "float,class:^(app.drey.Warp)$" # Warp-Gtk
    "float,class:^(net.davidotek.pupgui2)$" # ProtonUp-Qt
    "float,class:^(yad)$" # Protontricks-Gtk
    "float,class:^(eog)$" # Imageviewer-Gtk
    "float,class:^(io.github.alainm23.planify)$" # planify-Gtk
    "float,class:^(io.gitlab.theevilskeleton.Upscaler)$" # Upscaler-Gtk
    "float,class:^(com.github.unrud.VideoDownloader)$" # VideoDownloader-Gkk
    "float,class:^(io.gitlab.adhami3310.Impression)$" # Impression-Gtk
    "float,class:^(io.missioncenter.MissionCenter)$" # MissionCenter-Gtk
  ];

  # █░░ ▄▀█ █▄█ █▀▀ █▀█   █▀█ █░█ █░░ █▀▀ █▀
  # █▄▄ █▀█ ░█░ ██▄ █▀▄   █▀▄ █▄█ █▄▄ ██▄ ▄█

  layerrule = [
    "blur,rofi"
    "ignorezero,rofi"
    "blur,notifications"
    "ignorezero,notifications"
    "blur,swaync-notification-window"
    "ignorezero,swaync-notification-window"
    "blur,swaync-control-center"
    "ignorezero,swaync-control-center"
    "blur,logout_dialog"
  ];
}
