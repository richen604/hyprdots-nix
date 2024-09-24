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
  options.programs.hyprdots = {
    enable = mkEnableOption "enable hyprdots";
    theme = mkOption {
      type = types.enum (builtins.attrNames themes);
      default = "Catppuccin Mocha";
      description = "Theme for the dotfiles, fetches from hyde-gallery theme database";
    };
    fileOverrides = mkOption {
      type = types.attrsOf types.path;
      default = { };
      description = "Attribute set of files to override, e.g. { '.zshrc' = ./path/to/custom/zshrc; }";
    };
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # Zsh
      zsh-powerlevel10k

      # GTK Themeing
      gtk3
      gtk4
      gsettings-desktop-schemas
      libsForQt5.qtstyleplugins
      kdePackages.qtstyleplugin-kvantum

      # Fonts
      meslo-lgs-nf

      # Hyprdots
      hyprdotsDrv

      # Add the icon theme package
      themes.${cfg.theme}.iconTheme.package
    ];

    home.file = mkMerge [

      # Main hyprdots files from build, see build.sh for more details on the directory structure of hyprdots
      (mapAttrs' (
        name: _:
        nameValuePair "${name}" {
          source = "${hyprdotsDrv}/hyprdots/${name}";
          recursive = true;
          force = false;
        }
      ) (builtins.readDir "${hyprdotsDrv}/hyprdots"))

      # overrides for hyprdots files
      {
        ".zshrc" = {
          source = ./dotfiles/.zshrc;
          force = false;
        };
      }

      # User specified file overrides
      (mapAttrs' (
        name: path:
        nameValuePair name {
          source = path;
          recursive = true;
          force = false;
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
      runSwwwallcache = lib.hm.dag.entryAfter [ "copyWallpapers" ] ''
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

    stylix = {
      # image is required, but this is overridden by hyprdots later
      image = config.lib.stylix.pixel "base0A";
      enable = true;
      polarity = "dark";
      base16Scheme = themes.${cfg.theme}.base16;
      cursor = {
        package = themes.${cfg.theme}.cursor.package or pkgs.bibata-cursors;
        name = themes.${cfg.theme}.cursor.name or "Bibata-Modern-Ice";
      };
    };

  };
}
