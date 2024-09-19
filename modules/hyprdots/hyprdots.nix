{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.hyprdots;

  # Most themes are available at https://github.com/HyDE-Project/hyde-gallery
  themeJSON = (
    builtins.fromJSON (
      builtins.readFile (
        pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/HyDE-Project/hyde-gallery/hyde-gallery/hyde-themes.json";
          sha256 = "sha256-ZCrIgtfyPdh5OlXu4fKr4Bld+NAeULOrWHzUDMzzfXM=";
        }
      )
    )
  );

  themeShas = {
    "Catppuccin Mocha" = "sha256-YbT1Rm49igI3H1wH21V5f+npjgbj0ya0Dfh9tM62nVI=";
    "Catppuccin Macchiato" = lib.fakeSha256;
    "Catppuccin Frappe" = lib.fakeSha256;
    "Catppuccin Latte" = lib.fakeSha256;
  };
  fetchTheme =
    { theme }:
    let
      # we need to parse github information from the JSON
      themeData = builtins.head (builtins.filter (t: t.THEME == theme) themeJSON);

      owner = builtins.head (builtins.match "https://github.com/([^/]+).*" themeData.LINK);
      repo = builtins.head (builtins.match "https://github.com/[^/]+/([^/]+).*" themeData.LINK);
      rev = builtins.head (builtins.match "https://github.com/[^/]+/[^/]+/tree/([^/]+).*" themeData.LINK);
      sha256 = themeShas.${theme};
      name = "hyprdots-theme";
    in
    pkgs.fetchFromGitHub {
      inherit
        owner
        repo
        rev
        sha256
        name
        ;
    };

  hyprdotsDrv = pkgs.stdenv.mkDerivation {
    pname = "hyprdots";
    version = "0.1.0";
    srcs = [
      (pkgs.fetchFromGitHub {
        owner = "prasanthrangan";
        repo = "hyprdots";
        rev = "main";
        name = "hyprdots-source";
        sha256 = "sha256-qIVty9nuuFsw6Kd2r42Yerzm/Cp4KbvjdJE9oYGZgXA=";
      })
      (fetchTheme {
        inherit (cfg) theme;
      })
    ];

    sourceRoot = ".";

    buildInputs = [ pkgs.jq ];

    # buildPhase =
    #   let
    #     args = builtins.toJSON {
    #       inherit (cfg) theme;
    #     };
    #   in
    #   ''
    #     ${pkgs.bash}/bin/bash ${./build.sh} '${args}'
    #   '';

    installPhase = ''
      mkdir -p $out/hyprdots
      ls -a
      cp -rv hyprdots-source/* $out/hyprdots/
      # cp -r hyprdots-theme/* $out/hyprdots/
      # crash on purpose
      # false
    '';
  };

in

{
  options.programs.hyprdots = {
    enable = mkEnableOption "enable hyprdots";

    theme = mkOption {
      type = types.str;
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
    home.packages = [
      hyprdotsDrv
    ];

    home.file = mkMerge [
      # Main hyprdots files from build
      {
        ".config" = {
          source = "${hyprdotsDrv}/hyprdots/Configs/.config";
          recursive = true;
          force = true;
        };

        ".icons" = {
          source = "${hyprdotsDrv}/hyprdots/Configs/.icons";
          recursive = true;
          force = true;
        };

        ".local" = {
          source = "${hyprdotsDrv}/hyprdots/Configs/.local";
          recursive = true;
          force = true;
        };

        ".gtkrc-2.0" = {
          source = "${hyprdotsDrv}/hyprdots/Configs/.gtkrc-2.0";
          force = true;
        };

        ".p10k.zsh" = {
          source = "${hyprdotsDrv}/hyprdots/Configs/.p10k.zsh";
          force = true;
        };

        ".zshrc" = {
          source = "${hyprdotsDrv}/hyprdots/Configs/.zshrc";
          force = true;
        };

        "hyprdots_ls.txt" = {
          text = builtins.readFile (
            pkgs.runCommand "ls-hyprdots" { } ''
              ls -Ra ${hyprdotsDrv}/hyprdots > $out
            ''
          );
        };
      }

      # User specified file overrides
      # (mapAttrs' (name: path: nameValuePair name { source = path; }) cfg.fileOverrides)
    ];
  };
}
