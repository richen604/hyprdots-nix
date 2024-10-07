{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    rofi-wayland-unwrapped
  ];

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland-unwrapped;
    font = "JetBrainsMono Nerd Font Mono 12";
    theme = ./theme.rasi;
  };
}
