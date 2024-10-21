{
  pkgs,
}:

pkg: iconName:
pkgs.stdenv.mkDerivation {
  name = "hyde-${pkg.name}-icon-theme";
  version = "1.0.0";

  src = pkg.src;

  nativeBuildInputs = [
    pkgs.gnutar
    pkgs.gzip
    pkgs.jdupes
  ];

  dontConfigure = true;
  dontBuild = true;
  dontDropIconThemeCache = true;
  dontPatchELF = true;
  dontRewriteSymlinks = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons/${iconName}

    # Find and extract the icon theme tar file
    find . -name "Icon_*.tar.*" -print0 | xargs -0 -I {} tar xf {} -C $out/share/icons/${iconName} --strip-components=1

    jdupes -r $out/share/icons/${iconName}

    runHook postInstall
  '';

  meta = pkg.meta;
}
