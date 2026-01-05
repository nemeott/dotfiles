{ pkgs, ... }:

let
  nrdiff = pkgs.writeShellScriptBin "nrdiff" ''
    nixos-rebuild build "$@" && nvd diff /run/current-system result
  '';
in
{
  programs.bat.enable = true; # cat
  programs.zoxide.enable = true; # cd

  environment.systemPackages = with pkgs; [
    # # atuin
    bat-extras.batman # man
    bat-extras.batpipe
    btop # top
    eza # ls
    fd # find
    fzf # fuzzy finder
    ripgrep # grep

    bash-completion # Needed by atuin
    xclip # Needed for aliases interacting with the clipboard

    fastfetch

    nvd # NixOS version diff
    nrdiff # Custom diff command to rebuild and get the diff
  ];

  environment.shellAliases = {
    nrs = "nixos-rebuild switch";
    nrb = "nixos-rebuild boot";
    nrbb = "nixos-rebuild boot && reboot";
    nrbs = "nixos-rebuild boot && shutdown -h now";
    nrt = "nixos-rebuild test";

    nsp = "nix-shell -p";
  };
}
