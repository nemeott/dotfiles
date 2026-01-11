{
  username,
  ...
}:

{
  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.11";

    file.".bashrc".source = ../../../.bashrc;
    file.".bash_aliases".source = ../../../.bash_aliases;
  };
}
