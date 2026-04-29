_:

{
  # Enabled here for automatic Catppuccin integration
  programs = {
    # Shell history
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

    # git diff (used with lazygit)
    delta = {
      enable = true;
      options = {
        syntax-theme = "Catppuccin Mocha";
        
        keep-plus-minus-markers = true;
        # plus-style = "syntax";
        # minus-style = "syntax";
        # plus-non-emph-style = "syntax";
        # minus-non-emph-style = "syntax";
        # plus-emph-style = "syntax";
        # minus-emph-style = "syntax";
      };
    };
  };
}
