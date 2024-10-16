{
  username,
  gitUser,
  gitEmail,
  ...
}:

{

  home.username = username;
  home.homeDirectory = "/home/${username}";

  imports = [
    ./hydenix
  ];

  modules.hydenix = {
    enable = true;
    git = {
      userName = "${gitUser}";
      userEmail = "${gitEmail}";
    };
  };

  home.stateVersion = "24.11";
}
