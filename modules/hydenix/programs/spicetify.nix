{
  pkgs,
  ...
}:
let
  spicetify-sleek = import ../sources/spicetify-sleek.nix { inherit pkgs; };
in
{
  programs.spicetify = {
    enable = true;
    theme = {
      name = "Sleek";
      src = spicetify-sleek.pkg;
    };
    colorScheme = "Wallbash";
  };
}
