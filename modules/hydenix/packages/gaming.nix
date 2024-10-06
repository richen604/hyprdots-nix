{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # --------------------------------------------------- // Gaming
    steam # gaming platform
    gamemode # daemon and library for game optimisations
    mangohud # system performance overlay
    gamescope # micro-compositor for gaming
    lutris # gaming platform
  ];
}
