{ pkgs, lib, ... }:

theme: {
  # Extract GTK theme
  ".themes/${theme.arcs.gtk.name or "default-gtk"}" = lib.mkIf (theme.arcs.gtk != null) {
    source = "${theme.arcs.gtk.package}/share/themes/${theme.arcs.gtk.name}";
    force = true;
    mutable = true;
    recursive = true;
  };

  # TODO: icons cannot be extracted this way as it causes home-manager to crash
  # # Extract icon theme
  # ".icons/${theme.arcs.icon.name or "default-icon"}" = lib.mkIf (theme.arcs.icon != null) {
  #   source = "${theme.arcs.icon.package}/share/icons/${theme.arcs.icon.name}";
  #   force = true;
  #   mutable = true;
  #   recursive = true;
  #   executable = true;
  # };

  # Extract cursor theme
  ".icons/${theme.arcs.cursor.name or "default-cursor"}" = lib.mkIf (theme.arcs.cursor != null) {
    source = "${theme.arcs.cursor.package}/share/icons/${theme.arcs.cursor.name}";
    force = true;
    mutable = true;
  };

  # Extract fonts
  ".local/share/fonts/${theme.arcs.font.name or "default-font"}" =
    lib.mkIf (theme.arcs.font != null)
      {
        source = theme.arcs.font.package;
        force = true;
        mutable = true;
      };

  ".local/share/fonts/${theme.arcs.documentFont.name or "default-document-font"}" =
    lib.mkIf (theme.arcs.documentFont != null)
      {
        source = "${theme.arcs.documentFont.package}";
        force = true;
        mutable = true;
      };

  ".local/share/fonts/${theme.arcs.monospaceFont.name or "default-monospace-font"}" =
    lib.mkIf (theme.arcs.monospaceFont != null)
      {
        source = theme.arcs.monospaceFont.package;
        force = true;
        mutable = true;
      };

  ".config/hyde/themes/${theme.name}" = {
    source = theme.pkg;
    force = true;
    mutable = true;
    recursive = true;
  };

}
