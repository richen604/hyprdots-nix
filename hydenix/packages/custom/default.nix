{
  pkgs,
  ...
}:
{
  home.packages = [
    (pkgs.callPackage ./pokemon-colorscripts.nix { })
  ];
}
