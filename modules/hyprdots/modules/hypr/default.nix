{
  lib,
  ...
}:
let
  animations = import ./animations.nix;
  keybindings = import ./keybindings.nix { inherit lib; };
  windowrules = import ./windowrules.nix;
  userprefs = import ./userprefs.nix;
  themes = import ./themes.nix;
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = lib.mkMerge [
      {
        # █▀▄▀█ █▀█ █▄░█ █ ▀█▀ █▀█ █▀█
        # █░▀░█ █▄█ █░▀█ █ ░█░ █▄█ █▀▄

        # See https://wiki.hyprland.org/Configuring/Monitors/
        monitor = [
          ",preferred,auto,auto"
        ];

        # █░░ ▄▀█ █░█ █▄░█ █▀▀ █░█
        # █▄▄ █▀█ █▄█ █░▀█ █▄▄ █▀█

        # See https://wiki.hyprland.org/Configuring/Keywords/
        exec-once = [
          "$HOME/.local/share/bin/resetxdgportal.sh" # reset XDPH for screenshare
          "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP" # for XDPH
          "dbus-update-activation-environment --systemd --all" # for XDPH
          "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP" # for XDPH
          "$HOME/.local/share/bin/polkitkdeauth.sh" # authentication dialogue for GUI apps
          "if [ -d /var/tmp/waybar_temp ]; then waybar --config /var/tmp/waybar_temp/config.jsonc --style /var/tmp/waybar_temp/style.css; else waybar; fi" # launch the system bar
          "blueman-applet" # systray app for Bluetooth
          "udiskie --no-automount --smart-tray" # front-end that allows to manage removable media
          "nm-applet --indicator" # systray app for Network/Wifi
          "dunst" # start notification demon
          "wl-paste --type text --watch cliphist store" # clipboard store text data
          "wl-paste --type image --watch cliphist store" # clipboard store image data
          "$HOME/.local/share/bin/swwwallpaper.sh" # start wallpaper daemon
          "$HOME/.local/share/bin/batterynotify.sh" # battery notification
        ];

        # █▀▀ █▄░█ █░█
        # ██▄ █░▀█ ▀▄▀

        # See https://wiki.hyprland.org/Configuring/Environment-variables/
        env = [
          "PATH,$PATH:$HOME/.local/share/bin"
          "XDG_CURRENT_DESKTOP,Hyprland"
          "XDG_SESSION_TYPE,wayland"
          "XDG_SESSION_DESKTOP,Hyprland"
          "QT_QPA_PLATFORM,wayland;xcb"
          "QT_QPA_PLATFORMTHEME,qt6ct"
          "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
          "QT_AUTO_SCREEN_SCALE_FACTOR,1"
          "MOZ_ENABLE_WAYLAND,1"
          "GDK_SCALE,1"
        ];

        # █ █▄░█ █▀█ █░█ ▀█▀
        # █ █░▀█ █▀▀ █▄█ ░█░

        # See https://wiki.hyprland.org/Configuring/Variables/
        input = {
          kb_layout = "us";
          follow_mouse = 1;

          touchpad = {
            natural_scroll = false;
          };

          sensitivity = 0;
          force_no_accel = 1;
        };

        # See https://wiki.hyprland.org/Configuring/Keywords/#executing
        device = {
          name = "epic mouse V1";
          sensitivity = -0.5;
        };

        # See https://wiki.hyprland.org/Configuring/Variables/
        gestures = {
          workspace_swipe = true;
          workspace_swipe_fingers = 3;
        };

        # █░░ ▄▀█ █▄█ █▀█ █░█ ▀█▀ █▀
        # █▄▄ █▀█ ░█░ █▄█ █▄█ ░█░ ▄█

        # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/
        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };

        # See https://wiki.hyprland.org/Configuring/Master-Layout/
        master = {
          new_status = "master";
        };

        # █▀▄▀█ █ █▀ █▀▀
        # █░▀░█ █ ▄█ █▄▄

        # See https://wiki.hyprland.org/Configuring/Variables/
        misc = {
          vrr = 0;
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          force_default_wallpaper = 0;
        };

        xwayland = {
          force_zero_scaling = true;
        };
      }
      # █▀ █▀█ █░█ █▀█ █▀▀ █▀▀
      # ▄█ █▄█ █▄█ █▀▄ █▄▄ ██▄

      animations
      keybindings
      windowrules
      themes
      # # Note: as userprefs.conf is sourced at the end, settings configured in this file will override the defaults
      userprefs
    ];
  };
}
