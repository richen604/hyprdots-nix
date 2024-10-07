{
  config,
  pkgs,
  lib,
  ...
}:

let
  discordConfigDir =
    if pkgs.stdenv.hostPlatform.isDarwin then
      "Library/Application Support/discord"
    else
      "${config.xdg.configHome}/discord";

  pathsToMakeWritable = [
    "${discordConfigDir}/settings.json"
    "${discordConfigDir}/0.0.27/modules/discord_desktop_core/index.js"
    "${discordConfigDir}/Local Storage"
    "${discordConfigDir}/Code Cache"
    "${discordConfigDir}/Cookies"
    "${discordConfigDir}/Preferences"
  ];
in
{
  # Make the configuration files and directories mutable
  home.file = lib.genAttrs pathsToMakeWritable (path: {
    force = true;
    mutable = true;
    source = config.lib.file.mkOutOfStoreSymlink path;
  });
}
