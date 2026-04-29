{ inputs, username, ... }:

let
  dotfilesPath = ../../..;
in
{
  imports = [
    inputs.catppuccin.homeModules.catppuccin
    inputs.nix-index-database.homeModules.default

    ../../modules/packages/cli.home.nix
    ../../modules/packages/yazi.home.nix
  ];

  catppuccin.enable = true;

  home = {
    inherit username;
    homeDirectory = "/data/data/com.termux.nix/files/home";
    stateVersion = "24.05";

    file = {
      # Bash
      ".bashrc".source = "${dotfilesPath}/.bashrc";
      ".bash_aliases".source = "${dotfilesPath}/.bash_aliases";

      # # Allow unfree packages for shells
      # ".config/nixpkgs/config.nix".source = "${dotfilesPath}/nixpkgs/config.nix";

      # TODO: Keep secret
      # # Give Nix an access token to avoid rate-limiting
      # ".config/nix/nix.conf".source = "${dotfilesPath}/nix/nix.conf";

      # Clang format
      ".clang-format".source = "${dotfilesPath}/.clang-format";
    };
  };

  programs = {
    gh.enable = true;

    # Locate Nix packages and provide command-not-found integration
    nix-index = {
      enable = true;
      enableBashIntegration = true; # TODO: Why doesn't this work (command-not-found)
    };
    nix-index-database.comma.enable = true; # nix-shell and nix-index wrapper
  };
}
