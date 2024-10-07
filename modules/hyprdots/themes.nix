{ pkgs, lib }:

{

  # TODO: Documentation for themes
  # TODO: refactor themes to be their own modules
  # TODO: download wallpapers manually
  # Themes can be configured here. supports hyprdots themes and base16 themes.
  # wallpapers can be either fetched or in a local path.
  # Hyprdots themes: https://github.com/hyprdots/hyde-gallery
  # Base16 themes: https://tinted-theming.github.io/base16-gallery/

  # ----------- HYDE THEMES -----------
  "Catppuccin Mocha" = {
    base16 = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    gtk = {
      package = pkgs.catppuccin-gtk;
      name = "Catppuccin-Mocha";
    };
    iconTheme = {
      package = pkgs.tela-circle-icon-theme.override {
        colorVariants = [ "dracula" ];
      };
      name = "Tela-circle-dracula";
    };
    polarity = "dark";
    wallpapers = pkgs.fetchFromGitHub {
      owner = "prasanthrangan";
      repo = "hyde-themes";
      name = "wallpapers";
      rev = "d2052a18ed6e1f9e6d70c3431d27bf94f42be628";
      sha256 = "sha256-YbT1Rm49igI3H1wH21V5f+npjgbj0ya0Dfh9tM62nVI=";
    };
    font = {
      sansSerif = {
        name = "Cantarell";
        size = 10;
      };
      monospace = {
        name = "CaskaydiaCove Nerd Font Mono";
        size = 9;
      };
    };
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 20;
    };
    themeOverrides = {
      waybar = {
        theme = ''
          @define-color bar-bg rgba(0, 0, 0, 0);
          @define-color main-bg #11111b;
          @define-color main-fg #cdd6f4;
          @define-color wb-act-bg #a6adc8;
          @define-color wb-act-fg #313244;
          @define-color wb-hvr-bg #f5c2e7;
          @define-color wb-hvr-fg #313244;
        '';
      };
      rofi = {
        theme = ''
          * {
              main-bg:            #11111be6;
              main-fg:            #cdd6f4ff;
              main-br:            #cba6f7ff;
              main-ex:            #f5e0dcff;
              select-bg:          #b4befeff;
              select-fg:          #11111bff;
              separatorcolor:     transparent;
              border-color:       transparent;
          }
        '';
      };
      hyprland = {
        settings = {
          exec = ''
            gsettings set org.gnome.desktop.interface icon-theme 'Tela-circle-dracula'
            gsettings set org.gnome.desktop.interface gtk-theme 'Catppuccin-Mocha'
            gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
          '';

          general = {
            gaps_in = 3;
            gaps_out = 8;
            border_size = 2;
            col = {
              active_border = "rgba(ca9ee6ff) rgba(f2d5cfff) 45deg";
              inactive_border = "rgba(b4befecc) rgba(6c7086cc) 45deg";
            };
            layout = "dwindle";
            resize_on_border = true;
          };

          group = {
            col = {
              border_active = "rgba(ca9ee6ff) rgba(f2d5cfff) 45deg";
              border_inactive = "rgba(b4befecc) rgba(6c7086cc) 45deg";
              border_locked_active = "rgba(ca9ee6ff) rgba(f2d5cfff) 45deg";
              border_locked_inactive = "rgba(b4befecc) rgba(6c7086cc) 45deg";
            };
          };

          decoration = {
            rounding = 10;
            drop_shadow = false;

            blur = {
              enabled = true;
              size = 6;
              passes = 3;
              new_optimizations = "on";
              ignore_opacity = "on";
              xray = false;
            };
          };

          layerrule = "blur,waybar";
        };
      };
      kitty.themeFile = "${pkgs.kitty-themes}/themes/Catppuccin-Mocha.conf";
    };
  };
  "Catppuccin Latte" = {
    base16 = "${pkgs.base16-schemes}/share/themes/catppuccin-latte.yaml";
    iconTheme = {
      package = pkgs.tela-circle-icon-theme.override {
        colorVariants = [ "grey" ];
      };
      name = "Tela-circle-grey";
    };
    polarity = "light";
    wallpapers = pkgs.fetchFromGitHub {
      owner = "prasanthrangan";
      repo = "hyde-themes";
      name = "wallpapers";
      rev = "2b526598b76ae613d1de42fd3b089ba919ea6aec";
      sha256 = "sha256-kjHjcNcktEKLusIey/L4rbychUiib/suxGStq4zg7Pw=";
    };
  };
  "Decay Green" = {
    # TODO: figure out what base16 theme this matches, good first issue
    # https://raw.githubusercontent.com/prasanthrangan/hyprdots/main/Source/assets/theme_decay_2.png
    base16 = "${pkgs.base16-schemes}/share/themes/decay-green.yaml";
    iconTheme = {
      package = pkgs.tela-circle-icon-theme.override {
        colorVariants = [ "green" ];
      };
      name = "Tela-circle-green";
    };
    polarity = "dark";
    wallpapers = pkgs.fetchFromGitHub {
      owner = "prasanthrangan";
      repo = "hyde-themes";
      name = "wallpapers";
      rev = "1287bb71b1519c8fdab2bba642a7b24ec8364b6c";
      sha256 = lib.fakeSha256;
    };
    # TODO: Edge Runner
    # TODO: Frosted Glass
    # TODO: Graphite Mono
    # TODO: Rose Pine
    # TODO: Synthwave
  };
  "Gruvbox Retro" = {
    base16 = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
    iconTheme = {
      package = pkgs.gruvbox-dark-icons-gtk;
      name = "gruvbox-dark-icons-gtk";
    };
    polarity = "dark";
    wallpapers = pkgs.fetchFromGitHub {
      owner = "prasanthrangan";
      repo = "hyde-themes";
      name = "wallpapers";
      rev = "11e0face8c74526fca5519f47cbe90458eef6cd1";
      sha256 = "sha256-p8eGJGj7JzuOmE+7TAlC3wu1HYC/aBCobptGC1oMzbo=";
    };
    # TODO: figure out what cursor this is, or build it as a derivation from
    # https://github.com/prasanthrangan/hyde-themes/tree/Gruvbox-Retro/Source
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
    };
  };
  "Material Sakura" = {
    base16 = "${pkgs.base16-schemes}/share/themes/sakura.yaml";
    iconTheme = {
      package = pkgs.tela-circle-icon-theme.override {
        colorVariants = [ "black" ];
      };
      name = "Tela-circle-black";
    };
    polarity = "light";
    wallpapers = pkgs.fetchFromGitHub {
      owner = "prasanthrangan";
      repo = "hyde-themes";
      name = "wallpapers";
      rev = "76077f39ed496a4b84d38473b0419343734c323e";
      sha256 = lib.fakeSha256;
    };
  };
  "Nordic Blue" = {
    base16 = "${pkgs.base16-schemes}/share/themes/nordic.yaml";
    iconTheme = {
      package = pkgs.nordzy-icon-theme;
      name = "Nordzy";
    };
    polarity = "dark";
    wallpapers = pkgs.fetchFromGitHub {
      owner = "prasanthrangan";
      repo = "hyde-themes";
      name = "wallpapers";
      rev = "ce70a3524c7ff538ee4544088cc4b1b3091bd739";
      sha256 = lib.fakeSha256;
    };
  };
  "Tokyo Night" = {
    base16 = "${pkgs.base16-schemes}/share/themes/tokyo-night-terminal-dark.yaml";
    gtk = {
      package = pkgs.tokyonight-gtk-theme;
      name = "Tokyo-Night";
    };
    iconTheme = {
      package = pkgs.tela-circle-icon-theme.override {
        colorVariants = [ "purple" ];
      };
      name = "Tela-circle-purple";
    };
    polarity = "dark";
    wallpapers = pkgs.fetchFromGitHub {
      owner = "prasanthrangan";
      repo = "hyde-themes";
      name = "wallpapers";
      rev = "da8c38b7a6927eb585203e28fb8e403203578fe5";
      sha256 = "sha256-YL91+Q7CIGT+Ams9FOdw343OgQ19NWz6GJZEG37Gg9A=";
    };
  };
}
