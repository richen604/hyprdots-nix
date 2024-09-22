{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.hyprdots;
  themes = import ./theme.nix { inherit pkgs lib; };

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
      (themes.fetchTheme { theme = cfg.theme; })
    ];

    sourceRoot = ".";
    buildInputs = [ pkgs.jq ];

    buildPhase = ''
      ${pkgs.bash}/bin/bash ${./build.sh} '${builtins.toJSON { inherit (cfg) theme; }}'
    '';

    #! useful debugging files
    # installPhase = ''
    #   false
    # '';

  };
in
{
  options.programs.hyprdots = {
    enable = mkEnableOption "enable hyprdots";
    theme = mkOption {
      type = types.enum themes.availableThemes;
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
      themes.themeData.${cfg.theme}.gtk.package

      # Fonts
      meslo-lgs-nf

      # Hyprdots
      hyprdotsDrv
    ];
    home.file = mkMerge [

      # Main hyprdots files from build, see build.sh for more details on the directory structure of hyprdots
      (mapAttrs' (
        name: _:
        nameValuePair "${name}" {
          source = "${hyprdotsDrv}/hyprdots/${name}";
          recursive = true;
          force = true;
        }
      ) (builtins.readDir "${hyprdotsDrv}/hyprdots"))

      # overrides for hyprdots files
      {
        ".zshrc" = {
          source = ./dotfiles/.zshrc;
          force = true;
        };
      }

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
          force = true;
        };
      }
    ];

    stylix = {
      image = config.lib.stylix.pixel "base0A";
      enable = true;
      polarity = "dark";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    };

  };
}
