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
    # Screen locker
    swaylock = {
      enable = true;
      settings.color = lib.mkDefault "000000"; # Pure black for battery saving (override Catppuccin)
    };
  };

  services.swayidle =
    let
      lock = "${lib.getExe' pkgs.swaylock "swaylock"} --daemonize";
    in
    {
      enable = true;
      events = {
        lock = lock;
        before-sleep = lock;
      };
      timeouts = [
        {
          timeout = 180; # 3 minutes
          command = lock;
        }
      ];
    };
}
