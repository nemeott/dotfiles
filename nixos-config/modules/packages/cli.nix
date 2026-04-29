{ pkgs, username, ... }:

let
  flake-path = "path:/home/${username}/dotfiles";

  # Scripts to get the diff of the current system with a new build
  nrdiff = pkgs.writeShellScriptBin "nrdiff" ''
    nixos-rebuild build --flake ${flake-path} "$@" && nvd diff /run/current-system result
  '';

  # Custom script to display Zswap stats
  zswap-stats = pkgs.writeShellScriptBin "zswap" (builtins.readFile ../../../scripts/zswap.sh);

  # Custom script to create a .envrc file with "use nix" for direnv
  direnv-init = pkgs.writeShellScriptBin "direnv-init" ''
    if [ -e .envrc ]; then
      read -r -p "Overwrite .envrc? [y/N] " a
      [ "$a" = y ] || exit 0
    else
      echo ".envrc created"
    fi
    echo "use nix" > .envrc
  '';
in
{
  # programs.bat.enable = true; # cat (cli.home.nix)
  programs.zoxide.enable = true; # cd

  environment.systemPackages = with pkgs; [
    #
    # Packages
    #

    # Better coreutils
    # atuin # shell history (cli.home.nix)
    bat-extras.batman # man
    bat-extras.batpipe
    # btop # top (cli.home.nix)
    # eza # ls (cli.home.nix)
    fd # find
    # fzf # fuzzy finder (cli.home.nix)
    ripgrep # grep

    bash-completion # Needed by atuin

    # Fun
    fastfetch
    cpufetch
    gpufetch
    neo # Why not

    # Tools
    gdu # Fast disk usage analyzer
    powertop # Power utils
    systemctl-tui # Terminal-based systemctl interface
    bitwise # Terminal-based bit manipulator and calculator
    tlrc # Simple man pages
    navi # Interactive cheatsheet tool (Get tldr man pages with: `navi repo add tao3k/navi-tldr-pages`)
    nvd # NixOS version diff
    nixmate # Useful semi-nix related multitool
    surge-downloader # Fast TUI downlaod manager
    llmfit # TUI for finding good LLMs for local use
    models # TUI for displaying and comparing LLM providers and benchmarks
    
    #
    # Aliases and scripts
    #

    nrdiff # Custom diff command to rebuild and get the diff

    zswap-stats # Custom shell script to display zswap stats

    direnv-init # Custom shell script to create a .envrc file with "use nix" for direnv
  ];

  environment.shellAliases = {
    nfu = "nix flake update";
    
    nrt = "nixos-rebuild test --flake ${flake-path}";
    nrtm = "nixos-rebuild test 2>&1 | nixmate"; # Pipe error output to nixmate

    nrs = "nixos-rebuild switch --flake ${flake-path}";

    nrb = "nixos-rebuild boot --flake ${flake-path}";
    nrbb = "nixos-rebuild boot --flake ${flake-path} && reboot";
    nrbs = "nixos-rebuild boot --flake ${flake-path} && shutdown -h now";

    ns = "nix-shell";
    nsp = "nix-shell -p";

    nb = "nix-build";
    nba = "nix-build -A";

    # Get option from main flake
    no = "nixos-option --flake ${flake-path}";
  };
}
