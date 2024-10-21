{ pkgs }:

let
  mkFontDerivation =
    {
      name,
      url,
      sha256,
    }:
    pkgs.stdenv.mkDerivation {
      inherit name;
      src = pkgs.fetchurl {
        inherit url sha256;
      };
      unpackPhase = "tar xzf $src";
      installPhase = ''
        mkdir -p $out/share/fonts/truetype
        cp -r . $out/share/fonts/truetype
      '';
    };

  fontDerivations = [
    (mkFontDerivation {
      name = "cascadia-code";
      url = "https://github.com/prasanthrangan/hyprdots/raw/refs/heads/main/Source/arcs/Font_CascadiaCove.tar.gz";
      sha256 = "sha256-xtQJ++bi2eY/G62lLw7J3VGQvFpV33ijA98tyv782m0=";
    })
    (mkFontDerivation {
      name = "jetbrains-mono";
      url = "https://github.com/prasanthrangan/hyprdots/raw/refs/heads/main/Source/arcs/Font_JetBrainsMono.tar.gz";
      sha256 = "sha256-+oOEGwkgFq44Efm+ER0y7MtFbMlSP2oISJpwINT/s3o=";
    })
    (mkFontDerivation {
      name = "maple";
      url = "https://github.com/prasanthrangan/hyprdots/raw/refs/heads/main/Source/arcs/Font_MapleNerd.tar.gz";
      sha256 = "sha256-3bshil2SQthUgM8+lSvNebSLvCxxW9CZvxAYvg2bVmg=";
    })
    (mkFontDerivation {
      name = "material-design-icons";
      url = "https://github.com/prasanthrangan/hyprdots/raw/refs/heads/main/Source/arcs/Font_MaterialDesign.tar.gz";
      sha256 = "sha256-OEfQJOou3uAQVLMS5xiUDqt4XJfNWSGL8lxuSdlUVVE=";
    })
    (mkFontDerivation {
      name = "mononoki";
      url = "https://github.com/prasanthrangan/hyprdots/raw/refs/heads/main/Source/arcs/Font_MononokiNerd.tar.gz";
      sha256 = "sha256-TCXjopJEDNg8YtYoCMIqs1M43Yj8c+LKBc8RLMFaV58=";
    })
    (mkFontDerivation {
      name = "noto-sans-cjk";
      url = "https://github.com/prasanthrangan/hyprdots/raw/refs/heads/main/Source/arcs/Font_NotoSansCJK.tar.gz";
      sha256 = "sha256-OBAR4lXW/Zx9sD/cvmt/mm7zeUt/xdW8kk9QYR5E/2U=";
    })
  ];
in
pkgs.symlinkJoin {
  name = "hyde-fonts";
  paths = fontDerivations;
}
