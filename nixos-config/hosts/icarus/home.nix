{ inputs, username, ... }:

let
  dotfilesPath = ../../..;
in
{
  imports = [
    inputs.catppuccin.homeModules.catppuccin
    inputs.nix-index-database.homeModules.default

    ../../modules/packages/cli.home.nix
    ../../modules/packages/dev.home.nix
    ../../modules/packages/yazi.home.nix
    ../../modules/packages/zen-browser.home.nix
    ../../modules/niri.home.nix
  ];

  catppuccin.enable = true;

  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.11";

    file = {
      # Bash
      ".bashrc".source = "${dotfilesPath}/.bashrc";
      ".bash_aliases".source = "${dotfilesPath}/.bash_aliases";

      # Allow unfree packages for shells
      ".config/nixpkgs/config.nix".source = "${dotfilesPath}/nixpkgs/config.nix";

      # TODO: Keep secret
      # # Give Nix an access token to avoid rate-limiting
      # ".config/nix/nix.conf".source = "${dotfilesPath}/nix/nix.conf";

      # Niri
      ".config/niri/config.kdl".source = "${dotfilesPath}/niri/config.kdl";

      # Clang format
      ".clang-format".source = "${dotfilesPath}/.clang-format";
    };
  };
}
