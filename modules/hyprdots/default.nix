{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.hyprdots;

  themes = import ./themes.nix { inherit pkgs lib; };

  hyprdotsDrv = pkgs.stdenv.mkDerivation {
    pname = "hyprdots";
    version = "0.1.0";
    srcs = [
      (pkgs.fetchFromGitHub {
        owner = "prasanthrangan";
        repo = "hyprdots";
        rev = "7881e8503857dbe702409d882cc709af8e9f720d";
        name = "hyprdots-source";
        sha256 = "sha256-Xm8HM7+rU4u43X0sLholBk46XTm5kp+ooMLFyPX6GhA=";
      })
    ];

    sourceRoot = ".";
    buildInputs = [ pkgs.jq ];

    buildPhase = ''
      ${pkgs.bash}/bin/bash ${./build.sh} '${
        builtins.toJSON {
          inherit (cfg) theme;
          wallpapers = themes.${cfg.theme}.wallpapers;
        }
      }'
    '';

    # #! useful debugging files
    # installPhase = ''
    #   false
    # '';

  };
in
{
  imports = [
    ./modules/hypr
  ];
  options.programs.hyprdots = {
    enable = mkEnableOption "enable hyprdots";
    theme = mkOption {
      type = types.enum (builtins.attrNames themes);
      default = "Catppuccin Mocha";
      description = "Theme for the dotfiles, fetches from hyde-gallery theme database";
    };

    git = {
      userName = mkOption {
        type = types.str;
        default = "";
        description = "Git user name";
      };
      userEmail = mkOption {
        type = types.str;
        default = "";
        description = "Git user email";
      };
    };
  };
  config = mkIf cfg.enable {

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
      (python3.withPackages (
        ps: with ps; [
          pygobject3
        ]
      ))
      trash-cli # cli to manage trash files
      libinput-gestures # actions touchpad gestures using libinput
      gnomeExtensions.window-gestures # gui for libinput-gestures
      lm_sensors # system sensors
      pciutils # pci utils

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

      # --------------------------------------------------- // Window Manager
      hyprland # wlroots-based wayland compositor
      dunst # notification daemon
      rofi-wayland-unwrapped # application launcher
      waybar # system bar
      swww # wallpaper
      swaylock # lock screen
      swaylock-fancy # lock screen
      wlogout # logout menu
      grimblast # screenshot tool
      hyprpicker # color picker
      slurp # region select for screenshot/screenshare
      swappy # screenshot editor
      cliphist # clipboard manager

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
      themes.${cfg.theme}.iconTheme.package # icon theme
      desktop-file-utils # for updating desktop database
      # --------------------------------------------------- // Applications

      firefox # browser
      kitty # terminal
      dolphin # kde file manager
      ark # kde file archiver
      vim # terminal text editor
      vscode # ide text editor
      # neovim # vim based text editor
      code-cursor # ai vscode text editor

      # --------------------------------------------------- // Shell

      eza # file lister for zsh
      oh-my-zsh # plugin manager for zsh
      zsh-powerlevel10k # theme for zsh
      starship # customizable shell prompt
      fastfetch # system information fetch tool
      (callPackage ../pokemon-colorscripts.nix { }) # display pokemon sprites
      git # distributed version control system
      fzf # command line fuzzy finder

      # --------------------------------------------------- // Gaming
      steam # gaming platform
      gamemode # daemon and library for game optimisations
      mangohud # system performance overlay
      gamescope # micro-compositor for gaming
      lutris # gaming platform

      # --------------------------------------------------- // Music
      cava # audio visualizer
      spotify # proprietary music streaming service
      spicetify-cli # cli to customize spotify client

      # --------------------------------------------------- // HyDE
      # hyde-cli-git # cli tool to manage hyde # TODO: future: build hydecli with script changes?

      # Hyprdots
      hyprdotsDrv
      home-manager

    ];
    home.file = {
      # Main hyprdots files from build, see build.sh for more details on the directory structure of hyprdots
      # TODO: port entire hyprdots config to nix, below listed by priority
      ".config/hyde" = {
        source = "${hyprdotsDrv}/hyprdots/.config/hyde";
        recursive = true;
      };
      ".config/cava" = {
        source = "${hyprdotsDrv}/hyprdots/.config/cava";
        recursive = true;
      };
      ".config/fish" = {
        source = "${hyprdotsDrv}/hyprdots/.config/fish";
        recursive = true;
      };
      ".local/share/bin" = {
        source = ./modules/scripts;
        recursive = true;
        force = true;
      };
      ".config/rofi" = {
        source = "${hyprdotsDrv}/hyprdots/.config/rofi";
        recursive = true;
      };
      ".config/waybar" = {
        source = "${hyprdotsDrv}/hyprdots/.config/waybar";
        recursive = true;
      };
      ".p10k.zsh" = {
        source = "${hyprdotsDrv}/hyprdots/.p10k.zsh";
        force = true;
      };
      ".config/dunst" = {
        source = "${hyprdotsDrv}/hyprdots/.config/dunst";
        recursive = true;
      };
      ".config/dolphinrc" = {
        source = "${hyprdotsDrv}/hyprdots/.config/dolphinrc";
        recursive = true;
      };
      # Useful debugging files
      "hyprdots_ls.txt" = {
        text = builtins.readFile (
          pkgs.runCommand "ls-hyprdots" { } ''
            ls -Ra ${hyprdotsDrv}/hyprdots > $out
          ''
        );
      };
      "hyprdots_build.txt" = {
        source = "${hyprdotsDrv}/hyprdots/hyprdots_build.txt";
        force = false;
      };
    };

    home.activation = {
      runSwwwallcache = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
        export PATH="${
          lib.makeBinPath [
            pkgs.gawk
            pkgs.coreutils
            pkgs.gnused
            pkgs.gnutar
            pkgs.gzip
            pkgs.parallel
            pkgs.bash
            pkgs.imagemagick
          ]
        }:$PATH"
        ${pkgs.bash}/bin/bash $HOME/.local/share/bin/swwwallcache.sh
      '';
    };

    # GTK configuration
    gtk = {
      enable = true;
      iconTheme = {
        name = themes.${cfg.theme}.iconTheme.name;
        package = themes.${cfg.theme}.iconTheme.package;
      };
    };

    home.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    xdg = {
      enable = true;
      userDirs = {
        enable = true;
        createDirectories = true;
        desktop = "$HOME/Desktop";
        documents = "$HOME/Documents";
        download = "$HOME/Downloads";
        music = "$HOME/Music";
        pictures = "$HOME/Pictures";
        publicShare = "$HOME/Public";
        templates = "$HOME/Templates";
        videos = "$HOME/Videos";
      };
    };

    # TODO: (home-manager) implement optionals eg. fish, kitty, etc
    programs = {
      home-manager.enable = true;
      git = {
        enable = true;
        userName = "${cfg.git.userName}";
        userEmail = "${cfg.git.userEmail}";
      };
      kitty.enable = true;
      rofi = {
        enable = true;
        package = pkgs.rofi-wayland-unwrapped;
      };
      waybar.enable = true;
      vscode.enable = true;
      neovim = {
        enable = true;
        defaultEditor = true;
      };
      swaylock.enable = true;
      zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        oh-my-zsh = {
          enable = true;
          plugins = [
            "git"
            "history"
            "sudo"
          ];
        };
        initExtra = ''
          source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
          source ~/.p10k.zsh
        '';
        initExtraFirst = ''
          #Display Pokemon
          pokemon-colorscripts --no-title -r 1-3
          # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
          # Initialization code that may require console input (password prompts, [y/n]
          # confirmations, etc.) must go above this block; everything else may go below.
          if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
            source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
          fi
        '';
      };
    };

    # TODO: (stylix) add font support from themes
    # TODO: (stylix) add overrides from themes
    stylix = {
      # image is required, this is the primary color that generates base16 themes
      image = config.lib.stylix.pixel "base00";
      enable = true;
      polarity = themes.${cfg.theme}.polarity;
      base16Scheme = themes.${cfg.theme}.base16;
      cursor = {
        package = themes.${cfg.theme}.cursor.package or pkgs.bibata-cursors;
        name = themes.${cfg.theme}.cursor.name or "Bibata-Modern-Ice";
      };
      targets = {
        neovim.transparentBackground.main = true;
        kitty.variant256Colors = true;
        gtk.extraCss = ''
          gtk-cursor-theme-size=20
          gtk-toolbar-style=GTK_TOOLBAR_ICONS
          gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
          gtk-button-images=0
          gtk-menu-images=0
          gtk-enable-event-sounds=1
          gtk-enable-input-feedback-sounds=0
          gtk-xft-antialias=1
          gtk-xft-hinting=1
          gtk-xft-hintstyle=hintfull
          gtk-xft-rgba=rgb
          gtk-application-prefer-dark-theme=0
        '';
      };
    };

  };
}
