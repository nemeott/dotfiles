{ ... }:

{
  # Enabled here for automatic Catppuccin integration
  programs = {
    # shell history
    atuin = {
      enable = true;
      settings = {
        enter_accept = true; # Enter executes command immediately
        history_filter = [
          "^cd$"
          "^ls$"
          "^y$"
          "^clear$"
          "^bash$"
          "^exit"
          "^history"
          "^reboot$"
          "^nrt$"
          "^nrtu$"
          "^nrs$"
          "^nrsu$"
          "^nrb$"
          "^nrbu$"
          "^nrbb$"
          "^nrbub$"
          "^nrbs$"
          "^nrbus$"
          "^ns$"
          "^nsp$"
          "^nb$"
          "^nba$"
          "^no$"
          "^colist$"
          "^coclean$"
          "^conuke$"
          "^btop$"
          "^ptop$"
          "^ff$"
          "^sys$"
          "^lg$"
          "^y$"
        ];
      };
    };
    bat.enable = true; # cat
    btop.enable = true; # top
    eza.enable = true; # ls
    fzf.enable = true; # fuzzy finder
    delta.enable = true; # git diff (used with lazygit)
  };
}
