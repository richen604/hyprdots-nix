{ pkgs, ... }:
{
  imports = [
    ./mutable
    ./hyde.nix
    ./hyde-cli.nix
  ];

  home.packages = [
    (pkgs.callPackage ./pokemon-colorscripts.nix { })
  ];
}
