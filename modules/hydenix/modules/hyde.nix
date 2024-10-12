{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.modules.hyde;

  themes = import ./sources/themes.nix { inherit pkgs; };

  hyprdots = import ./sources/hyde.nix { inherit pkgs; };
  hyde-cli = import ./sources/hyde-cli.nix { inherit pkgs lib; };

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
        ".themes/Wallbash-Gtk" = {
          source = "${hyprdots.pkg}/unpacked/Wallbash-Gtk";
          force = true;
          recursive = true;
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
