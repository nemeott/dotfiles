# Test eval with: nix eval .#nixOnDroidConfigurations.daedalus.activationPackage --impure

{ inputs, pkgs, ... }:

let
  flake-path = "path:/data/data/com.termux.nix/files/home/dotfiles";

  # Script to get the diff of the current system with a new build
  nrdiff = pkgs.writeShellScriptBin "nrdiff" ''
    nix-on-droid build --flake ${flake-path} "$@" && nvd diff /run/current-system result
  '';

  nrn = pkgs.writeShellScriptBin "nrn" ''
    nix run nixpkgs#"$@"
  '';

  nrh = pkgs.writeShellScriptBin "nrh" ''
    nix run .#"$@"
  '';

  nbn = pkgs.writeShellScriptBin "nbn" ''
    nix build "''${@/#/nixpkgs#}"
  '';

  nbh = pkgs.writeShellScriptBin "nbh" ''
    nix build "''${@/#/.#}"
  '';

  nsn = pkgs.writeShellScriptBin "nsn" ''
    nix shell "''${@/#/nixpkgs#}"
  '';

  nsh = pkgs.writeShellScriptBin "nsh" ''
    nix shell "''${@/#/.#}"
  '';

  # Custom script to create a .envrc file with "use nix" for direnv
  direnv-init = pkgs.writeShellScriptBin "direnv-init" ''
    if [ -e .envrc ]; then
      read -r -p "Overwrite .envrc? [y/N] " a
      [ "$a" = y ] || exit 0
    else
      echo ".envrc created"
    fi
    echo "use flake" > .envrc
  '';
in
{
  environment.packages = with pkgs; [
    bash
    nano

    procps
    killall
    diffutils
    util-linux
    hostname
    man
    gawk # awk
    gnused # sed
    ncurses # clear

    wget
    curl
    git
    openssh

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
    trash-cli
    zoxide

    bash-completion # Needed by atuin

    # Fun
    fastfetch
    cpufetch
    # gpufetch
    neo # Why not

    # Tools
    gdu # Fast disk usage analyzer
    powertop # Power utils
    # glab-tui # Terminal interface for GitHub and GitLab
    bitwise # Terminal-based bit manipulator and calculator
    tlrc # Simple man pages
    navi # Interactive cheatsheet tool (Get tldr man pages with: `navi repo add tao3k/navi-tldr-pages`)
    nvd # NixOS version diff
    # nixmate # Useful semi-nix related multitool
    inputs.multiverse.packages.${pkgs.stdenv.hostPlatform.system}.mvs # nixpkgs multiverse (old packages)
    # surge-downloader # Fast TUI downlaod manager
    # llmfit # TUI for finding good LLMs for local use
    # (inputs.models.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (old: {
    #   doCheck = false;
    # })) # TUI for displaying and comparing LLM providers and benchmarks

    #
    # Aliases and scripts
    #

    nrdiff # Custom diff command to rebuild and get the diff

    nsn # nix shell nixpkgs# expand helper
    nsh # nix shell .# expand helper (nix shell here)
    nbn # nix build nixpkgs# expand helper
    nbh # nix build .# expand helper (nix build here)
    nrn # nix run nixpkgs# expand helper
    nrh # nix run .# expand helper (nix run here)

    direnv-init # Custom shell script to create a .envrc file with "use nix" for direnv
  ];

  terminal.font = "${pkgs.monaspace}/share/fonts/truetype/MonaspaceNeonFrozen-Regular.ttf";

  # Set time zone and select internationalisation properties
  time.timeZone = "America/New_York";

  environment.etcBackupExtension = ".bak";

  # Don't build NixOS manual to improve build times
  documentation.nixos.enable = false; # ~5 sec

  system.stateVersion = "24.05";

  nix.extraOptions = ''
    experimental-features = nix-command flakes

    keep-derivations = true # Default?
    keep-outputs = true # Keep build outputs for fast package rebuilds
  '';
}
