{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # --------------------------------------------------- // Shell
    eza # file lister for zsh
    oh-my-zsh # plugin manager for zsh
    zsh-powerlevel10k # theme for zsh
    starship # customizable shell prompt
    fastfetch # system information fetch tool
    git # distributed version control system
    fzf # command line fuzzy finder
  ];
}
