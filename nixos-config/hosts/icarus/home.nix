{ inputs, username, ... }:

let
  dotfilesPath = ../../..;
in
{
  imports = [
    inputs.catppuccin.homeModules.catppuccin

    ../../modules/packages/cli-home.nix
    ../../modules/packages/zen-browser-home.nix
    ../../modules/niri-home.nix
  ];

  catppuccin.enable = true;

  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.11";

    file = {
      ".bashrc".source = "${dotfilesPath}/.bashrc";
      ".bash_aliases".source = "${dotfilesPath}/.bash_aliases";

      ".config/niri/config.kdl".source = "${dotfilesPath}/niri/config.kdl";
    };
  };
}
