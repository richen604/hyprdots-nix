{ lib, ... }:

let
  inherit (lib) mkMerge;
in
{
  # █▄▀ █▀▀ █▄█ █▄▄ █ █▄░█ █▀▄ █ █▄░█ █▀▀ █▀
  # █░█ ██▄ ░█░ █▄█ █ █░▀█ █▄▀ █ █░▀█ █▄█ ▄█

  # See https://wiki.hyprland.org/Configuring/Keywords/
  #  &  https://wiki.hyprland.org/Configuring/Binds/

  # Main modifier
  "$mainMod" = "Super"; # super / meta / windows key
  "$scrPath" = "$HOME/.local/share/bin";

  # Assign apps
  "$term" = "kitty";
  "$editor" = "code";
  "$file" = "dolphin";
  "$browser" = "firefox";

  bind = mkMerge [
    # Window/Session actions
    [
      "$mainMod SHIFT, P, exec, hyprpicker -a" # Pick color (Hex) >> clipboard
      "$mainMod, Q, exec, $scrPath/dontkillsteam.sh" # close focused window
      "ALT, F4, exec, $scrPath/dontkillsteam.sh" # close focused window
      "$mainMod, Delete, exit" # kill hyprland session
      "$mainMod, W, togglefloating" # toggle the window between focus and float
      "$mainMod, G, togglegroup" # toggle the window between focus and group
      "ALT, Return, fullscreen" # toggle the window between focus and fullscreen
      "$mainMod, L, exec, swaylock" # launch lock screen
      "$mainMod SHIFT, F, exec, $scrPath/windowpin.sh" # toggle pin on focused window
      "$mainMod, Backspace, exec, $scrPath/logoutlaunch.sh" # launch logout menu
      "CTRL ALT, W, exec, killall .waybar-wrapped || waybar" # toggle waybar
    ]
    # Application shortcuts
    [
      "$mainMod, T, exec, $term" # launch terminal emulator
      "$mainMod, E, exec, $file" # launch file manager
      "$mainMod, C, exec, $editor" # launch text editor
      "$mainMod, F, exec, $browser" # launch web browser
      "CTRL SHIFT, Escape, exec, $scrPath/sysmonlaunch.sh" # launch system monitor
    ]
    # Rofi menus
    [
      "$mainMod, A, exec, pkill -x rofi || $scrPath/rofilaunch.sh d" # launch application launcher
      "$mainMod, Tab, exec, pkill -x rofi || $scrPath/rofilaunch.sh w" # launch window switcher
      "$mainMod SHIFT, E, exec, pkill -x rofi || $scrPath/rofilaunch.sh f" # launch file explorer
    ]
    # Move between grouped windows
    [
      "$mainMod CTRL, H, changegroupactive, b"
      "$mainMod CTRL, L, changegroupactive, f"
    ]
    # Screenshot/Screencapture
    [
      "$mainMod, P, exec, $scrPath/screenshot.sh s" # partial screenshot capture
      "$mainMod CTRL, P, exec, $scrPath/screenshot.sh sf" # partial screenshot capture (frozen screen)
      "$mainMod ALT, P, exec, $scrPath/screenshot.sh m" # monitor screenshot capture
      ", Print, exec, $scrPath/screenshot.sh p" # all monitors screenshot capture
    ]
    # Custom scripts
    [
      "$mainMod ALT, G, exec, $scrPath/gamemode.sh" # disable hypr effects for gamemode
      "$mainMod ALT, Right, exec, $scrPath/swwwallpaper.sh -n" # next wallpaper
      "$mainMod ALT, Left, exec, $scrPath/swwwallpaper.sh -p" # previous wallpaper
      "$mainMod ALT, Up, exec, $scrPath/wbarconfgen.sh n" # next waybar mode
      "$mainMod ALT, Down, exec, $scrPath/wbarconfgen.sh p" # previous waybar mode
      "$mainMod SHIFT, R, exec, pkill -x rofi || $scrPath/wallbashtoggle.sh -m" # launch wallbash mode select menu
      "$mainMod SHIFT, T, exec, pkill -x rofi || $scrPath/themeselect.sh" # launch theme select menu
      "$mainMod SHIFT, A, exec, pkill -x rofi || $scrPath/rofiselect.sh" # launch select menu
      "$mainMod SHIFT, W, exec, pkill -x rofi || $scrPath/swwwallselect.sh" # launch wallpaper select menu
      "$mainMod, V, exec, pkill -x rofi || $scrPath/cliphist.sh c" # launch clipboard
      "$mainMod SHIFT, V, exec, pkill -x rofi || $scrPath/cliphist.sh" # launch clipboard Manager
      "$mainMod, K, exec, $scrPath/keyboardswitch.sh" # switch keyboard layout
      "$mainMod, slash, exec, pkill -x rofi || $scrPath/keybinds_hint.sh c" # launch keybinds hint
    ]
    # Move/Change window focus
    [
      "$mainMod, Left, movefocus, l"
      "$mainMod, Right, movefocus, r"
      "$mainMod, Up, movefocus, u"
      "$mainMod, Down, movefocus, d"
      "ALT, Tab, movefocus, d"
    ]
    # Switch workspaces
    [
      "$mainMod, 1, workspace, 1"
      "$mainMod, 2, workspace, 2"
      "$mainMod, 3, workspace, 3"
      "$mainMod, 4, workspace, 4"
      "$mainMod, 5, workspace, 5"
      "$mainMod, 6, workspace, 6"
      "$mainMod, 7, workspace, 7"
      "$mainMod, 8, workspace, 8"
      "$mainMod, 9, workspace, 9"
      "$mainMod, 0, workspace, 10"
    ]
    # Switch workspaces to a relative workspace
    [
      "$mainMod CTRL, Right, workspace, r+1"
      "$mainMod CTRL, Left, workspace, r-1"
    ]
    # Move to the first empty workspace
    [
      "$mainMod CTRL, Down, workspace, empty"
    ]
    # Move focused window to a workspace
    [
      "$mainMod SHIFT, 1, movetoworkspace, 1"
      "$mainMod SHIFT, 2, movetoworkspace, 2"
      "$mainMod SHIFT, 3, movetoworkspace, 3"
      "$mainMod SHIFT, 4, movetoworkspace, 4"
      "$mainMod SHIFT, 5, movetoworkspace, 5"
      "$mainMod SHIFT, 6, movetoworkspace, 6"
      "$mainMod SHIFT, 7, movetoworkspace, 7"
      "$mainMod SHIFT, 8, movetoworkspace, 8"
      "$mainMod SHIFT, 9, movetoworkspace, 9"
      "$mainMod SHIFT, 0, movetoworkspace, 10"
    ]
    # Move focused window to a relative workspace
    [
      "$mainMod CTRL ALT, Right, movetoworkspace, r+1"
      "$mainMod CTRL ALT, Left, movetoworkspace, r-1"
    ]
    # Scroll through existing workspaces
    [
      "$mainMod, mouse_down, workspace, e+1"
      "$mainMod, mouse_up, workspace, e-1"
    ]
    # Move/Switch to special workspace (scratchpad)
    [
      "$mainMod ALT, S, movetoworkspacesilent, special"
      "$mainMod, S, togglespecialworkspace,"
    ]
    # Toggle focused window split
    [
      "$mainMod, J, togglesplit"
    ]
    # Move focused window to a workspace silently
    [
      "$mainMod ALT, 1, movetoworkspacesilent, 1"
      "$mainMod ALT, 2, movetoworkspacesilent, 2"
      "$mainMod ALT, 3, movetoworkspacesilent, 3"
      "$mainMod ALT, 4, movetoworkspacesilent, 4"
      "$mainMod ALT, 5, movetoworkspacesilent, 5"
      "$mainMod ALT, 6, movetoworkspacesilent, 6"
      "$mainMod ALT, 7, movetoworkspacesilent, 7"
      "$mainMod ALT, 8, movetoworkspacesilent, 8"
      "$mainMod ALT, 9, movetoworkspacesilent, 9"
      "$mainMod ALT, 0, movetoworkspacesilent, 10"
    ]
  ];

  bindl = [
    ", F10, exec, $scrPath/volumecontrol.sh -o m" # toggle audio mute
    ", XF86AudioMute, exec, $scrPath/volumecontrol.sh -o m" # toggle audio mute
    ", XF86AudioMicMute, exec, $scrPath/volumecontrol.sh -i m" # toggle microphone mute
    ", XF86AudioPlay, exec, playerctl play-pause" # toggle between media play and pause
    ", XF86AudioPause, exec, playerctl play-pause" # toggle between media play and pause
    ", XF86AudioNext, exec, playerctl next" # media next
    ", XF86AudioPrev, exec, playerctl previous" # media previous
  ];

  bindel = [
    ", F11, exec, $scrPath/volumecontrol.sh -o d" # decrease volume
    ", F12, exec, $scrPath/volumecontrol.sh -o i" # increase volume
    ", XF86AudioLowerVolume, exec, $scrPath/volumecontrol.sh -o d" # decrease volume
    ", XF86AudioRaiseVolume, exec, $scrPath/volumecontrol.sh -o i" # increase volume
    ", XF86MonBrightnessUp, exec, $scrPath/brightnesscontrol.sh i" # increase brightness
    ", XF86MonBrightnessDown, exec, $scrPath/brightnesscontrol.sh d" # decrease brightness
  ];

  binde = [
    "$mainMod SHIFT, Right, resizeactive, 30 0"
    "$mainMod SHIFT, Left, resizeactive, -30 0"
    "$mainMod SHIFT, Up, resizeactive, 0 -30"
    "$mainMod SHIFT, Down, resizeactive, 0 30"
  ];

  bindm = [
    "$mainMod, mouse:272, movewindow"
    "$mainMod, mouse:273, resizewindow"
    "$mainMod, Z, movewindow"
    "$mainMod, X, resizewindow"
  ];

  # TODO: on load fails with dispatcher error, fix
  # # Move active window around current workspace with mainMod + SHIFT + CTRL [←→↑↓]
  # "$moveactivewindow" = "grep -q \"true\" <<< $(hyprctl activewindow -j | jq -r .floating) && hyprctl dispatch moveactive";
  # binded = [
  #   "$mainMod SHIFT CONTROL, left, exec, $moveactivewindow -30 0 || hyprctl dispatch movewindow l"
  #   "$mainMod SHIFT CONTROL, right, exec, $moveactivewindow 30 0 || hyprctl dispatch movewindow r"
  #   "$mainMod SHIFT CONTROL, up, exec, $moveactivewindow 0 -30 || hyprctl dispatch movewindow u"
  #   "$mainMod SHIFT CONTROL, down, exec, $moveactivewindow 0 30 || hyprctl dispatch movewindow d"
  # ];

}
