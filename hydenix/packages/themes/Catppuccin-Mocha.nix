{
  pkgs,
}:
let
  name = "Catppuccin Mocha";

  src = pkgs.fetchFromGitHub {
    owner = "prasanthrangan";
    repo = "hyde-themes";
    rev = "Catppuccin-Mocha";
    sha256 = "sha256-YbT1Rm49igI3H1wH21V5f+npjgbj0ya0Dfh9tM62nVI=";
  };

  pkg = pkgs.stdenv.mkDerivation {
    name = name;
    src = src;

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      mkdir -p $out
      cp -r Configs/.config/hyde/themes/"${name}"/. $out/

      mkdir -p $out/wallpapers
      find . -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" \) -exec cp --no-preserve=mode {} $out/wallpapers/ \;
    '';

    meta = with pkgs.lib; {
      description = "HyDE Theme: Catppuccin Mocha";
      homepage = "https://github.com/prasanthrangan/hyde-themes/tree/Catppuccin-Mocha";
      license = licenses.mit;
      platforms = platforms.all;
    };
  };

  gtk = {
    name = "Catppuccin-Mocha";
    package = import ./utils/mkGtk.nix { inherit pkgs; } pkg "Catppuccin-Mocha";
  };

  icon = {
    name = "Tela-circle-dracula";
    package = import ./utils/mkIcon.nix { inherit pkgs; } pkg "Tela-circle-dracula";
  };

  walls = pkg.outPath + "/wallpapers";

in
{
  name = name;
  pkg = pkg;
  src = pkg.src;
  arcs = {
    gtk = gtk;
    icon = icon;
    cursor = null;
    font = null;
    documentFont = null;
    monospaceFont = null;
  };
  walls = walls;
}
