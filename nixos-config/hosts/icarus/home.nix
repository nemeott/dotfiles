{ inputs, username, ... }:

let
  dotfilesPath = ../../..;
in
{	
  imports = [
    inputs.catppuccin.homeModules.catppuccin
    
    ../../modules/packages/cli-home.nix
    ../../modules/niri-home.nix
    ../../modules/packages/zen-browser-home.nix
  ];

  catppuccin.enable = true;

  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.11";

    file.".bashrc".source = "${dotfilesPath}/.bashrc";
    file.".bash_aliases".source = "${dotfilesPath}/.bash_aliases";

    # file.".config/niri/config.kdl".source = "${dotfilesPath}/config.kdl";
  };
}

# Obsidian ctrl . instead of alt enter or zed alt enter
