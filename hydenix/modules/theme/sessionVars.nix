theme:
let
  defineIfNotNull = name: value: if value != null then { "${name}" = value.name; } else { };
in
defineIfNotNull "GTK_THEME" theme.arcs.gtk
// defineIfNotNull "ICON_THEME" theme.arcs.icon
// defineIfNotNull "CURSOR_THEME" theme.arcs.cursor
// defineIfNotNull "FONT" theme.arcs.font
// defineIfNotNull "DOCUMENT_FONT" theme.arcs.documentFont
// defineIfNotNull "MONOSPACE_FONT" theme.arcs.monospaceFont
