{ pkgs }:

pkg: gtkName:
pkgs.stdenv.mkDerivation {
  name = "hyde-${pkg.name}-gtk-theme";
  version = "1.0.0";

  src = pkg.src;

  nativeBuildInputs = [
    pkgs.gnutar
    pkgs.gzip
  ];

  dontConfigure = true;
  dontBuild = true;

  dontDropIconThemeCache = true;
  dontPatchELF = true;
  dontRewriteSymlinks = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/themes/${gtkName}

    # Find and extract the GTK theme tar file
    find . -name "Gtk_*.tar.*" -print0 | xargs -0 -I {} tar xf {} -C $out/share/themes/${gtkName} --strip-components=1

    runHook postInstall
  '';

  meta = pkg.meta;
}
