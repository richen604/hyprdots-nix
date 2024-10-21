{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # --------------------------------------------------- // Music
    cava # audio visualizer
    spicetify-cli # cli to customize spotify client
  ];
}
