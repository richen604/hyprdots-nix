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

    fileOverrides = mkOption {
      type = types.attrsOf types.path;
      default = { };
      description = "Attribute set of files to override, e.g. { '.zshrc' = ./path/to/custom/zshrc; }";
    };
  };
  config = mkIf cfg.enable {

    home.packages = with pkgs; [

      # XDG Desktop Portal
      xdg-desktop-portal
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland

      # Zsh
      zsh-powerlevel10k

      # GTK Themeing
      gtk3
      gtk4
      # gsettings-desktop-schemas
      gnome-settings-daemon
      glib
      libsForQt5.qtstyleplugins
      kdePackages.qtstyleplugin-kvantum

      # Fonts
      meslo-lgs-nf

      # Hyprdots
      hyprdotsDrv

      # Add the icon theme package
      themes.${cfg.theme}.iconTheme.package

      # Hyprdots dependencies
      dconf
      git
      gum
      coreutils
      findutils
      wget
      unzip
      jq
      kitty
      dunst
      lsd
      mangohud
      hyprland
      fastfetch
      qt5ct
      qt6ct
      waybar
      wlogout
      nwg-look
      dolphin
      libinput-gestures
      (callPackage ../pokemon-colorscripts.nix { })
      swaylock
      rofi-wayland-unwrapped
    ];

    home.file = mkMerge [

      # Main hyprdots files from build, see build.sh for more details on the directory structure of hyprdots
      # TODO: port entire hyprdots config to nix, below listed by priority
      # .gtkrc-2.0
      # .p10k.zsh
      #   - Kvantum
      # - .config/
      #   - fish
      #   - kitty
      #   - hyde

      #   - rofi
      #   - dunst
      #   - waybar
      #   - swaylock

      #   - Code-OSS/User
      #   - Code/User

      #   - fastfetch

      #   - lsd
      #   - menus

      #   - wlogout
      #   - xsettingsd
      #   - baloofilerc
      #   - dolphinrc

      #   - libinput-gestures.conf
      #   - low priority
      #     - MangoHud

      # handled by stylix OR not required

      #   - kdeglobals
      #   - gtk-3.0
      #   - nwg-look
      #   - qt5ct
      #   - qt6ct
      #   - spotify-flags.conf

      # done

      #   - hypr

      {
        ".config/hyde" = {
          source = "${hyprdotsDrv}/hyprdots/.config/hyde";
          recursive = true;
        };
      }

      {
        ".themes" = {
          source = "${hyprdotsDrv}/hyprdots/.themes";
          recursive = true;
        };
      }

      {
        ".config/qt5ct" = {
          source = "${hyprdotsDrv}/hyprdots/.config/qt5ct";
          recursive = true;
        };
      }

      {
        ".config/qt6ct" = {
          source = "${hyprdotsDrv}/hyprdots/.config/qt6ct";
          recursive = true;
        };
      }

      {
        ".config/Kvantum" = {
          source = "${hyprdotsDrv}/hyprdots/.config/Kvantum";
          recursive = true;
        };
      }

      {
        ".config/cava" = {
          source = "${hyprdotsDrv}/hyprdots/.config/cava";
          recursive = true;
        };
      }

      {
        ".config/fish" = {
          source = "${hyprdotsDrv}/hyprdots/.config/fish";
          recursive = true;
        };
      }

      {
        ".local/share/bin" = {
          source = ./modules/scripts;
          recursive = true;
          force = true;
        };
      }

      {
        ".config/rofi" = {
          source = "${hyprdotsDrv}/hyprdots/.config/rofi";
          recursive = true;
        };
      }

      {
        ".config/waybar" = {
          source = "${hyprdotsDrv}/hyprdots/.config/waybar";
          recursive = true;
        };
      }

      # {
      #   ".config/swaylock" = {
      #     source = "${hyprdotsDrv}/hyprdots/.config/swaylock";
      #     recursive = true;
      #     force = true;
      #   };
      # }

      {
        ".p10k.zsh" = {
          source = "${hyprdotsDrv}/hyprdots/.p10k.zsh";
          force = true;
        };
      }

      {
        ".config/dunst" = {
          source = "${hyprdotsDrv}/hyprdots/.config/dunst";
          recursive = true;
        };
      }

      {
        ".config/dolphinrc" = {
          source = "${hyprdotsDrv}/hyprdots/.config/dolphinrc";
          recursive = true;
        };
      }

      # {
      #   ".config/kitty" = {
      #     source = "${hyprdotsDrv}/hyprdots/.config/kitty";
      #     recursive = true;
      #   };
      # }

      # (mapAttrs' (
      #   name: _:
      #   nameValuePair "${name}" {
      #     source = "${hyprdotsDrv}/hyprdots/${name}";
      #     recursive = true;
      #     force = false;
      #   }
      # ) (builtins.readDir "${hyprdotsDrv}/hyprdots"))

      # User specified file overrides
      (mapAttrs' (
        name: path:
        nameValuePair name {
          source = path;
          recursive = true;
          force = true;
        }
      ) cfg.fileOverrides)

      #! useful debugging files
      {
        # Lists all files in the hyprdots directory
        "hyprdots_ls.txt" = {
          text = builtins.readFile (
            pkgs.runCommand "ls-hyprdots" { } ''
              ls -Ra ${hyprdotsDrv}/hyprdots > $out
            ''
          );
        };
        # Lists the build command and arguments
        "hyprdots_build.txt" = {
          source = "${hyprdotsDrv}/hyprdots/hyprdots_build.txt";
          force = false;
        };
      }
    ];

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

    fonts = {
      fontconfig = {
        enable = true;
        defaultFonts = {
          # sansSerif = themes.${cfg.theme}.font.sansSerif.name;
          # monospace = themes.${cfg.theme}.font.monospace.name;
        };
      };
    };

    # Qt
    qt = {
      enable = true;
      platformTheme.name = "gtk";
    };

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
      swaylock = {
        enable = true;
      };
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

    home.sessionVariables = {
      XDG_DATA_DIRS = "$XDG_DATA_DIRS:${pkgs.zsh}/share";
    };

    stylix = {
      # image is required, this is the primary color that generates base16 themes
      # TODO: create override
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
      };
    };

  };
}
