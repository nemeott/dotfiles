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
      # Disable swaylock if brightness is 0 (allows turning the screen off to let something run without interruption)
      conditional_lock = pkgs.writeShellApplication {
        name = "conditional_lock";
        runtimeInputs = [
          pkgs.swaylock
          pkgs.brightnessctl
          pkgs.coreutils
        ];
        text = ''
          # Read brightness percent and strip the % sign
          brightness=$(brightnessctl -m | cut -d, -f4 | sed 's/%//')

          # Don't start if 0 brightness
          if [ "$brightness" -gt 0 ]; then
            exec swaylock
          fi
        '';
      };

      conditional_suspend = pkgs.writeShellApplication {
        name = "conditional_suspend";
        runtimeInputs = [
          pkgs.brightnessctl
          pkgs.systemd
          pkgs.coreutils
        ];
        text = ''
          # Read brightness percent and strip the % sign
          brightness=$(brightnessctl -m | cut -d, -f4 | sed 's/%//')

          # Don't start if 0 brightness
          if [ "$brightness" -gt 0 ]; then
            exec systemctl suspend
          fi
        '';
      };

      lock = "${lib.getExe conditional_lock}";
      suspend = lib.getExe conditional_suspend;

      # lock = "${lib.getExe' pkgs.swaylock "swaylock"} --daemonize"; # Default
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
        {
          timeout = 1200; # 20 minutes
          command = suspend;
        }
      ];
    };
}
