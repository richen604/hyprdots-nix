{ pkgs, ... }:

{

  imports = [
    ./git.nix
    ./zsh.nix
  ];

  programs = {
    home-manager.enable = true;
    kitty.enable = true;
    rofi = {
      enable = true;
      package = pkgs.rofi-wayland-unwrapped;
    };
    waybar.enable = true;
    vscode.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    swaylock.enable = true;
    zsh.enable = true;
  };
}
