{ lib, pkgs, ... }:

{
  # Enabled here for automatic Catppuccin integration
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

  services.swayidle =
    let
      lock = "${lib.getExe' pkgs.swaylock "swaylock"} --daemonize";
    in
    {
      enable = true;
      events = [
        {
          event = "lock";
          command = lock;
        }
        {
          event = "before-sleep";
          command = lock;
        }
      ];
      timeouts = [
        {
          timeout = 60;
          command = lock;
        }
      ];
    };
}
