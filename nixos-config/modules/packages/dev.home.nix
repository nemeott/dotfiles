_:

{
  programs = {
    # Terminal emulator
    foot = {
      # Enabled here for automatic Catppuccin integration
      enable = true;
      settings = {
        colors-dark.alpha = 0.85;
        main = {
          term = "xterm-256color";
          font = "Monaspace Neon Frozen:size=8.5";
          pad = "1x1 center"; # Slight padding so text isn't super close to the edge
        };
        scrollback.lines = 100000; # Larger scrollback buffer (default is 10,000?)
      };
    };

    gh.enable = true;

    uv = {
      enable = true;
      settings = {
        exclude-newer = "10 days"; # Prevent supply-chain attacks
      };
    };

    # Locate Nix packages and provide command-not-found integration
    nix-index = {
      enable = true;
      enableBashIntegration = true; # TODO: Why doesn't this work (command-not-found) (because not using HM managed bashrc?)
    };
    nix-index-database.comma.enable = true; # nix-shell and nix-index wrapper
  };
}
