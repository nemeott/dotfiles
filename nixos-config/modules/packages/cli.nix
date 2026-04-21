{ pkgs, username, ... }:

let
  flake-path = "path:/home/${username}/dotfiles";

  # Scripts to get the diff of the current system with a new build
  nrdiff = pkgs.writeShellScriptBin "nrdiff" ''
    nixos-rebuild build --flake ${flake-path} "$@" && nvd diff /run/current-system result
  '';
  nrudiff = pkgs.writeShellScriptBin "nrudiff" ''
    nixos-rebuild build --flake ${flake-path} --upgrade "$@" && nvd diff /run/current-system result
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

    # Better CLIs
    # atuin # shell history (cli.home.nix)
    bat-extras.batman # man
    bat-extras.batpipe
    # btop # top (cli.home.nix)
    # eza # ls (cli.home.nix)
    fd # find
    # fzf # fuzzy finder (cli.home.nix)
    ripgrep # grep

    bash-completion # Needed by atuin
    xclip # Needed for aliases interacting with the clipboard

    # Fun
    fastfetch
    neo # Why not

    # Tools
    gdu # Fast disk usage analyzer
    powertop # Power utils
    systemctl-tui # Terminal-based systemctl interface
    bitwise # Terminal-based bit manipulator and calculator

    #
    # Aliases and scripts
    #

    nvd # NixOS version diff
    nrdiff # Custom diff command to rebuild and get the diff
    nrudiff # Custom diff command to rebuild with upgrade and get the diff

    zswap-stats # Custom shell script to display zswap stats

    direnv-init # Custom shell script to create a .envrc file with "use nix" for direnv
  ];

  environment.shellAliases = {
    nrt = "nixos-rebuild test --flake ${flake-path}";
    nrtu = "nixos-rebuild test --flake ${flake-path} --upgrade";

    nrs = "nixos-rebuild switch --flake ${flake-path}";
    nrsu = "nixos-rebuild switch --flake ${flake-path} --upgrade";

    nrb = "nixos-rebuild boot --flake ${flake-path}";
    nrbu = "nixos-rebuild boot --flake ${flake-path} --upgrade";
    nrbb = "nixos-rebuild boot --flake ${flake-path} && reboot";
    nrbub = "nixos-rebuild boot --flake ${flake-path} --upgrade && reboot";
    nrbs = "nixos-rebuild boot --flake ${flake-path} && shutdown -h now";
    nrbus = "nixos-rebuild boot --flake ${flake-path} --upgrade && shutdown -h now";

    ns = "nix-shell";
    nsp = "nix-shell -p";

    nb = "nix-build";
    nba = "nix-build -A";

    # Get option from a flake
    no = "nixos-option --flake ${flake-path}";
  };
}
