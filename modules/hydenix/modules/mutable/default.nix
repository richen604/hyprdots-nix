{ ... }:

{
  imports = [
    ./mutable.nix
    # TODO: spotify mutable
    # ./spotify-mutable.nix
    ./vscode-mutable.nix
    # TODO: discord mutable
    # ./discord-mutable.nix
    ./firefox-mutable.nix
  ];
}
