{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.programs.firefox;

  profilesPath =
    if pkgs.stdenv.hostPlatform.isDarwin then
      "Library/Application Support/Firefox/Profiles"
    else
      "${config.xdg.dataHome}/firefox";

  mkMutableFile = path: {
    force = true;
    mutable = true;
  };

  pathsToMakeWritable = lib.flatten [
    (lib.mapAttrsToList (name: profile: [
      "${profilesPath}/${profile.path}/user.js"
      "${profilesPath}/${profile.path}/chrome/userChrome.css"
      "${profilesPath}/${profile.path}/chrome/userContent.css"
      "${profilesPath}/${profile.path}/containers.json"
      "${profilesPath}/${profile.path}/search.json.mozlz4"
    ]) cfg.profiles)
  ];

in
{
  home.file = lib.genAttrs pathsToMakeWritable mkMutableFile;

}
