{ config, ... }:

let
  cfg = config.modules.hydenix;
in
{
  programs.git = {
    enable = true;
    userName = cfg.git.userName;
    userEmail = cfg.git.userEmail;
  };
}
