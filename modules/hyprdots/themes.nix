{ pkgs, lib }:

{

  # TODO: feat: fetch all themes from hyde-gallery and edit sha256
  # TODO: feat: add settings for all themes
  # TODO: Documentation for themes
  # TODO: wallpapers fetch
  # Themes can be configured here. supports hyprdots themes and base16 themes.
  # wallpapers can be either fetched or in a local path.
  # Hyprdots themes: https://github.com/hyprdots/hyde-gallery
  # Base16 themes: https://tinted-theming.github.io/base16-gallery/
  "Catppuccin Mocha" = {
    base16 = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    iconTheme = {
      package = pkgs.tela-circle-icon-theme.override {
        colorVariants = [ "dracula" ];
      };
      name = "Tela-circle-dracula";
    };
    wallpapers = pkgs.fetchFromGitHub {
      owner = "prasanthrangan";
      repo = "hyde-themes";
      name = "wallpapers";
      rev = "d2052a18ed6e1f9e6d70c3431d27bf94f42be628";
      sha256 = "sha256-99wmu1R/Q9tuithyYBlxlEvkixY4Ea6S/Pgdimdqhj4=";
      sparseCheckout = [
        "Configs/.config/hyde/themes/Catppuccin Mocha/wallpapers"
      ];
    };
  };
  "Catppuccin Macchiato" = {
    base16 = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
    iconTheme = {
      package = pkgs.tela-circle-icon-theme.override {
        colorVariants = [ "dracula" ];
      };
      name = "Tela-circle-dracula";
    };
  };
}
