{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    bash-completion

    # atuin
    bat # cat
    bat-extras.batman # man
    bat-extras.batpipe
    btop # top
    eza # ls
    fd # find
    fzf # fuzzy finder
    ripgrep # grep
    zoxide # cd

    fastfetch
  ];
}
