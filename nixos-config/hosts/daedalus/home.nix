{
  inputs,
  pkgs,
  lib,
  username,
  ...
}:

let
  dotfilesPath = ../../..;

  secrets = import ../../secrets.nix;

  flake-path = "path:/data/data/com.termux.nix/files/home/dotfiles";
in
{
  imports = [
    # inputs.catppuccin.homeModules.catppuccin # TODO: User different version for 24.05
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
      ".profile".source = "./.profile";

      # Clang format
      ".clang-format".source = "${dotfilesPath}/.clang-format";
    };
  };

  programs = {
    git = {
      enable = true;
      userName = "nemeott";
      userEmail = secrets.git-email;

      extraConfig = {
        init.defaultBranch = "main";
      };

      # git diff (used with lazygit)
      delta = {
        enable = true;
        options = {
          syntax-theme = "Catppuccin Mocha";
          keep-plus-minus-markers = true;
        };
      };
    };
    gh.enable = true;

    lazygit = {
      enable = true;
      settings = {
        git = {
          log.order = "default"; # Make Lazygit faster on large repos
          pagers = [ { pager = "delta --dark --paging=never"; } ]; # Use delta pager for diffs
        };
        keybinding.commits = {
          moveUpCommit = "<c-u>";
          moveDownCommit = "<c-d>"; # ctrl-j on Zed minimizes terminal
        };
      };
    };

    # Shell history
    atuin = {
      enable = true;
      settings = {
        enter_accept = true;
      };
    };

    bat.enable = true; # cat
    btop.enable = true; # top
    eza.enable = true; # ls
    fzf.enable = true; # fuzzy finder

    yazi.enable = true;

    # Locate Nix packages and provide command-not-found integration
    nix-index = {
      enable = true;
      enableBashIntegration = true;
    };
    nix-index-database.comma.enable = true; # nix-shell and nix-index wrapper

    # Development environments (installs direnv and nix-direnv)
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      config.global.disable_stdin = true;
      # silent = true;
    };
  };

  home.shellAliases = {
    nfu = "nix flake update";

    nrs = "nix-on-droid switch --flake ${flake-path}";

    ns = "nix-shell";
    nsp = "nix-shell -p";

    nb = "nix-build";
    nba = "nix-build -A";

    # Get option from main flake
    no = "nixos-option --flake ${flake-path}";
  };
}
