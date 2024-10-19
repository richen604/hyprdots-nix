{ config, ... }:

let
  cfg = config.hydenix;
in
{
  programs.git = {
    enable = true;
    userName = cfg.git.userName;
    userEmail = cfg.git.userEmail;
  };
}
