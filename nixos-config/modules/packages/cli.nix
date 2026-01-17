{ pkgs, username, ... }:

let
  flake-path = "path:/home/${username}/dotfiles";

  nrdiff = pkgs.writeShellScriptBin "nrdiff" ''
    nixos-rebuild build --flake ${flake-path} "$@" && nvd diff /run/current-system result
  '';
  nrudiff = pkgs.writeShellScriptBin "nrudiff" ''
    nixos-rebuild build --flake ${flake-path} --upgrade "$@" && nvd diff /run/current-system result
  '';
in
{
  # programs.bat.enable = true; # cat (cli-home.nix)
  programs.zoxide.enable = true; # cd

  environment.systemPackages = with pkgs; [
    # atuin # shell history (cli-home.nix)
    bat-extras.batman # man
    bat-extras.batpipe
    # btop # top (cli-home.nix)
    # eza # ls (cli-home.nix)
    fd # find
    # fzf # fuzzy finder (cli-home.nix)
    ripgrep # grep

    bash-completion # Needed by atuin
    xclip # Needed for aliases interacting with the clipboard

    gdu # Fast disk usage analyzer
    powertop # Power utils
    fastfetch

    nvd # NixOS version diff
    nrdiff # Custom diff command to rebuild and get the diff
    nrudiff # Custom diff command to rebuild with upgrade and get the diff
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

    nsp = "nix-shell -p";

    # Get option from a flake
    no = "nixos-option --flake ${flake-path}";
  };
}
