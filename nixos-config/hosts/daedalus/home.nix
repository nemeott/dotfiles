{
  inputs,
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
    inputs.nod-catppuccin.homeModules.catppuccin
    inputs.nix-index-database.homeModules.default

    ../../modules/packages/cli.home.nix
    ../../modules/packages/dev.home.nix
    ../../modules/packages/yazi.home.nix
  ];

  catppuccin.enable = true;

  home = {
    username = lib.mkForce username;
    homeDirectory = "/data/data/com.termux.nix/files/home";
    stateVersion = "24.05";

    file = {
      # Bash
      ".bashrc".source = "${dotfilesPath}/.bashrc";
      ".bash_aliases".source = "${dotfilesPath}/.bash_aliases";
      ".profile".source = ./.profile;

      # Clang format
      ".clang-format".source = "${dotfilesPath}/.clang-format";
    };
  };

  programs = {
    git = {
      enable = true;
      settings = {
        user.name = "nemeott";
        user.email = secrets.git-email;

        init.defaultBranch = "main";
      };
    };

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

    # Development environments (installs direnv and nix-direnv)
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      silent = true;
    };
  };

  home.shellAliases = {
    nfu = "nix flake update";

    nrt = "nixos-rebuild test --flake ${flake-path}";
    nrts = "nixos-rebuild test --flake ${flake-path} 2> /dev/null"; # Suppress output
    nrtm = "nixos-rebuild test 2>&1 | nixmate"; # Pipe error output to nixmate

    nrs = "nixos-rebuild switch --flake ${flake-path}";
    nrsm = "nixos-rebuild switch --flake ${flake-path} 2>&1 | nixmate"; # Pipe error output to nixmate

    nrb = "nixos-rebuild boot --flake ${flake-path}";
    nrbm = "nixos-rebuild boot --flake ${flake-path} 2>&1 | nixmate"; # Pipe error output to nixmate
    nrbb = "nixos-rebuild boot --flake ${flake-path} && reboot";
    nrbs = "nixos-rebuild boot --flake ${flake-path} && shutdown -h now";

    nd = "nix develop";
    nb = "nix build";

    # Get option from main flake
    no = "nixos-option --flake ${flake-path}";

    #
    # Old aliases for nix-shell and nix-build
    #

    # ns = "nix-shell";
    # nsp = "nix-shell -p";

    # nb = "nix-build";
    # nba = "nix-build -A";
  };
}
