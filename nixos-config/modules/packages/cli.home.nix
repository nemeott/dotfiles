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
    # top
    btop = {
      enable = true;
      settings = {
        theme_background = false; # Don't draw background so we can use transparency
        proc_sorting = "memory"; # Sort by memory usage
        proc_tree = true; # Show process tree
        proc_aggregate = true; # Aggregate processes by name (parent has all children's memory usage)
      };
    };
    eza.enable = true; # ls
    fzf.enable = true; # fuzzy finder

    # git diff (used with lazygit)
    delta = {
      enable = true;
      options = {
        syntax-theme = "Catppuccin Mocha";
        keep-plus-minus-markers = true;
      };
    };
  };
}
