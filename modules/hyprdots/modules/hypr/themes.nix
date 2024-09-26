{
  # █▀▀ █░█ █▀█ █▀ █▀█ █▀█
  # █▄▄ █▄█ █▀▄ ▄█ █▄█ █▀▄
  exec = [
    "hyprctl setcursor Bibata-Modern-Ice 20"
    "gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Ice'"
    "gsettings set org.gnome.desktop.interface cursor-size 20"

    # █▀▀ █▀█ █▄░█ ▀█▀
    # █▀░ █▄█ █░▀█ ░█░
    "gsettings set org.gnome.desktop.interface font-name 'Cantarell 10'"
    "gsettings set org.gnome.desktop.interface document-font-name 'Cantarell 10'"
    "gsettings set org.gnome.desktop.interface monospace-font-name 'CaskaydiaCove Nerd Font Mono 9'"
    "gsettings set org.gnome.desktop.interface font-antialiasing 'rgba'"
    "gsettings set org.gnome.desktop.interface font-hinting 'full'"

    # █▀ █▀█ █▀▀ █▀▀ █ ▄▀█ █░░
    # ▄█ █▀▀ ██▄ █▄▄ █ █▀█ █▄▄
    "gsettings set org.gnome.desktop.interface icon-theme 'Tela-circle-dracula'"
    "gsettings set org.gnome.desktop.interface gtk-theme 'Catppuccin-Mocha'"
    "gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'"
  ];

  decoration = {
    dim_special = 0.3;
  };

  general = {
    gaps_in = 3;
    gaps_out = 8;
    border_size = 2;
    layout = "dwindle";
    resize_on_border = true;
  };

  decoration = {
    rounding = 10;
    drop_shadow = false;

    blur = {
      enabled = true;
      size = 6;
      passes = 3;
      new_optimizations = "on";
      ignore_opacity = true;
      xray = false;
    };
  };
}
