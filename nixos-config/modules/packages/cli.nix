{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # atuin
    bat # cat
    bat-extras.batman
    bat-extras.batpipe
    btop # top
    eza # ls
    fd # find
    fzf # fuzzy finder
    ripgrep # grep
    zoxide # cd
  ];
  # TODO: Set aliases here
}