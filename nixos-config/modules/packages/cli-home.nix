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
          "^clear$"
          "^ls$"
          "^bash$"
        ];
      };
    };
    bat.enable = true; # cat
    btop.enable = true; # top
    eza.enable = true; # ls
    fzf.enable = true; # fuzzy finder
  };
}
