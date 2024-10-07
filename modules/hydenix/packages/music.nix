{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # --------------------------------------------------- // Music
    cava # audio visualizer
    spotify # proprietary music streaming service
    spicetify-cli # cli to customize spotify client
  ];
}
