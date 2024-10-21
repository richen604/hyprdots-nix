{ lib }:

themeName: theme:
let
  hyprThemeFile = "${theme}/Configs/.config/hyde/themes/${themeName}/hypr.theme";
  extractValue =
    name: fallbackName:
    let
      fileContent = builtins.readFile hyprThemeFile;
      newFormatRegex = ".*\\$" + name + "[[:space:]]*=[[:space:]]*([^[:space:]]+).*";
      oldFormatRegex =
        ".*exec[[:space:]]*=[[:space:]]*gsettings[[:space:]]+set[[:space:]]+org.gnome.desktop.interface[[:space:]]+"
        + fallbackName
        + "-theme[[:space:]]+[\"']([^\"']+)[\"'].*";
      newFormatMatch = builtins.match newFormatRegex fileContent;
      oldFormatMatch = builtins.match oldFormatRegex fileContent;
    in
    if newFormatMatch != null then
      lib.removeSuffix "\n" (builtins.head newFormatMatch)
    else if oldFormatMatch != null then
      lib.removeSuffix "\n" (builtins.head oldFormatMatch)
    else
      "";

in
{
  gtk = themeName: theme: extractValue "GTK-THEME" "gtk";
  icon = themeName: theme: extractValue "ICON-THEME" "icon";
  cursor = themeName: theme: extractValue "CURSOR-THEME" "cursor";
  font = themeName: theme: extractValue "FONT" "font";
  documentFont = themeName: theme: extractValue "DOCUMENT-FONT" "document";
  monospaceFont = themeName: theme: extractValue "MONOSPACE-FONT" "monospace";
}
