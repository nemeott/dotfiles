{ inputs, lib, username, ... }:

let
  dotfilesPath = ../../..;
in
{
  imports = [
    # inputs.catppuccin.homeModules.catppuccin
    inputs.nix-index-database.homeModules.default
  ];

  # catppuccin.enable = true;

  home = {
    username = lib.mkForce username;
    homeDirectory = "/data/data/com.termux.nix/files/home";
    stateVersion = "24.05";

    file = {
      # Bash
      ".bashrc".source = "${dotfilesPath}/.bashrc";
      ".bash_aliases".source = "${dotfilesPath}/.bash_aliases";

      # Clang format
      ".clang-format".source = "${dotfilesPath}/.clang-format";
    };
  };

  programs = {
    gh.enable = true;
    bash.enable = true;
    git.enable = true;

    # Basic CLI tools (separated from shared modules due to compatibility)
    bat.enable = true;
    btop.enable = true;
    eza.enable = true;
    fzf.enable = true;
    yazi.enable = true;
    atuin = {
      enable = true;
      settings = {
        enter_accept = true;
      };
    };

    # Locate Nix packages and provide command-not-found integration
    nix-index = {
      enable = true;
      enableBashIntegration = true;
    };
    nix-index-database.comma.enable = true; # nix-shell and nix-index wrapper
  };
}
