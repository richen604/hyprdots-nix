{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.modules.hyde;

  themes = import ../sources/themes.nix { inherit pkgs; };

  hyprdots = import ../sources/hyde.nix { inherit pkgs; };
  hyde-cli = import ../sources/hyde-cli.nix { inherit pkgs lib; };

  wallbash-gtk = import ../sources/wallbash-gtk.nix { inherit pkgs lib; };
  spicetify-sleek = import ../sources/spicetify-sleek.nix { inherit pkgs lib; };
in
{
  options.modules.hyde = {
    enable = lib.mkEnableOption "Hyde";

    themes = lib.mkOption {
      type = lib.types.listOf lib.types.string;
      default = [
        "Catppuccin Mocha"
      ];
    };
  };

  config = lib.mkIf cfg.enable {
    home.file = lib.mkMerge [
      {
        ".config" = {
          source = "${hyprdots.pkg}/Configs/.config";
          force = true;
          recursive = true;
          mutable = true;
        };
        ".local/share" = {
          source = "${hyprdots.pkg}/Configs/.local/share";
          force = true;
          recursive = true;
          mutable = true;
        };
        ".icons/default" = {
          source = "${hyprdots.pkg}/Configs/.icons/default";
          force = true;
          recursive = true;
          mutable = true;
        };
        ".p10k.zsh" = {
          source = "${hyprdots.pkg}/Configs/.p10k.zsh";
          force = true;
          mutable = true;
        };
        ".gtkrc-2.0" = {
          source = "${hyprdots.pkg}/Configs/.gtkrc-2.0";
          force = true;
          mutable = true;
        };
        ".local/hyprdots" = {
          source = hyprdots.pkg;
          force = true;
          recursive = true;
          mutable = true;
        };

        # Wallbash stuff
        ".themes/Wallbash-Gtk" = {
          source = "${wallbash-gtk.pkg}";
          force = true;
          recursive = true;
          mutable = true;
        };
        ".config/spicetify/Themes/Sleek" = {
          source = "${spicetify-sleek.pkg}";
          force = true;
          recursive = true;
          mutable = true;
        };

        # TODO: add needed extensions to hyde cache landing
        ".cache/hyde/landing/Code_Wallbash.vsix" = {
          source = "${hyprdots.pkg}/Source/arcs/Code_Wallbash.vsix";
          force = true;
          mutable = true;
        };
        ".cache/hyde/landing/Spotify_Sleek.tar.gz" = {
          source = "${hyprdots.pkg}/Source/arcs/Spotify_Sleek.tar.gz";
          force = true;
          mutable = true;
        };

      }
      # (lib.mapAttrs' (
      #   name: value:
      #   lib.nameValuePair ".config/hyde/themes/${name}" {
      #     source = value.theme;
      #     force = true;
      #     recursive = true;
      #     mutable = true;
      #   }
      # ) themes)
    ];

    home.activation = {
      # importHydeTheme = lib.hm.dag.entryAfter [ "hydeLink" ] ''
      #     export PATH="${lib.makeBinPath hyde-cli.buildInputs}:$PATH"

      #     $DRY_RUN_CMD env FORCE_THEME_UPDATE=true ${hyde-cli.pkg}/bin/Hyde theme import "Mac OS" $HOME/.cache/hyde/themes/Mac-Os
      #   # '';
    };
  };
}
