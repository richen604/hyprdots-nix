{
  config,
  pkgs,
  lib,
  ...
}:

let
  configDir =
    if pkgs.stdenv.hostPlatform.isDarwin then
      "Library/Application Support/Spotify"
    else
      "${config.xdg.configHome}/spotify";

  spicetifyConfigDir = "${config.xdg.configHome}/spicetify";

  spotifyPrefsPath = "${configDir}/prefs";
  spicetifyConfigPath = "${spicetifyConfigDir}/config-xpui.ini";
  spicetifyThemesPath = "${spicetifyConfigDir}/Themes";
  spicetifyExtensionsPath = "${spicetifyConfigDir}/Extensions";

  pathsToMakeWritable = [
    spotifyPrefsPath
    spicetifyConfigPath
    spicetifyThemesPath
    spicetifyExtensionsPath
  ];
in
{
  home.file = lib.genAttrs pathsToMakeWritable (path: {
    force = true;
    mutable = true;
    source = config.lib.file.mkOutOfStoreSymlink path;
  });
}
