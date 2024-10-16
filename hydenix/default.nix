{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.hydenix;
in
{
  imports = [
    ./modules
    ./packages
    ./programs
  ];

  options.modules.hydenix = {
    enable = mkEnableOption "hydenix";
    git = {
      userName = mkOption {
        type = types.str;
        description = "Git user name";
      };
      userEmail = mkOption {
        type = types.str;
        description = "Git user email";
      };
    };
  };

  config = mkIf cfg.enable {
    modules = {
      hyde.enable = true;
      hyde-cli.enable = true;
    };

    fonts.fontconfig.enable = true;

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
      ];
      config.common.default = "*";
    };

    wayland.windowManager.hyprland.systemd.variables = [ "--all" ];

    dconf = {
      enable = true;
      settings = {
        "org/gnome/desktop/interface" = {
          icon-theme = "Tela-circle-dracula";
          gtk-theme = "Wallbash-Gtk";
          color-scheme = "prefer-dark";
          font-name = "Cantarell 10";
          cursor-theme = "Bibata-Modern-Ice";
          cursor-size = 20;
          document-font-name = "Cantarell 10";
          monospace-font-name = "JetBrains Mono 9";
          font-antialiasing = "rgba";
          font-hinting = "full";
        };
      };
    };

    programs = {
      git = {
        enable = true;
        userName = cfg.git.userName;
        userEmail = cfg.git.userEmail;
      };

      zsh.enable = true;
    };

    services = {
      blueman-applet.enable = true;
    };

    home.sessionVariables = {
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      MOZ_ENABLE_WAYLAND = 1;
      XDG_SESSION_TYPE = "wayland";
      QT_QPA_PLATFORM = "wayland";
      GDK_BACKEND = "wayland";
      NIXOS_OZONE_WL = "1";
      EDITOR = "nvim";
    };
  };
}
