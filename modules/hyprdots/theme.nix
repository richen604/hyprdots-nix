{ pkgs, lib, ... }:

# Fetches themes from the JSON "database" at https://github.com/HyDE-Project/hyde-gallery
# Themes are then fetched from GitHub and built locally.
# theme data is then used in the hyprdots module to install the themes.

let
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

  # TODO: feat: fetch all themes from hyde-gallery and edit sha256
  # TODO: feat: add settings for all themes
  themeData = {
    "Catppuccin Mocha" = {
      sha256 = "sha256-YbT1Rm49igI3H1wH21V5f+npjgbj0ya0Dfh9tM62nVI=";
      gtk = {
        package = pkgs.catppuccin-gtk.override {
          accents = [ "rosewater" ];
          variant = "mocha";
        };
        name = "Catppuccin-Mocha";
      };
      iconTheme = {
        package = pkgs.tela-circle-icon-theme.override {
          colorVariants = [ "dracula" ];
        };
        name = "Tela-circle-dracula";
      };
    };
    "Catppuccin Macchiato" = {
      sha256 = lib.fakeSha256;
      gtk = "Catppuccin-Macchiato-Standard-Rosewater-Dark";
      icon = "Catppuccin-Macchiato-Standard-Rosewater-Dark";
    };
  };

  fetchTheme =
    { theme }:
    let
      themeInfo = builtins.head (builtins.filter (t: t.THEME == theme) themeJSON);
      owner = builtins.head (builtins.match "https://github.com/([^/]+).*" themeInfo.LINK);
      repo = builtins.head (builtins.match "https://github.com/[^/]+/([^/]+).*" themeInfo.LINK);
      rev = builtins.head (builtins.match "https://github.com/[^/]+/[^/]+/tree/([^/]+).*" themeInfo.LINK);
    in
    pkgs.fetchFromGitHub {
      inherit owner repo rev;
      sha256 = themeData.${theme}.sha256;
      name = "hyprdots-theme";
    };

in
{
  inherit fetchTheme themeData;
  availableThemes = builtins.attrNames themeData;
}
