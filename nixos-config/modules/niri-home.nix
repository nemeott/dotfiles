{ ... }:

{
  programs = {
    # Terminal emulator
    foot = {
      enable = true;
      settings = {
        main = {
          term = "xterm-256color";
          font = "Monaspace Neon Frozen:size=8.5";
        };
      };
    };
    fuzzel.enable = true; # Application launcher
    swaylock.enable = true; # Screen locker
  };
}
