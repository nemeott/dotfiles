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
          pkgs.gnused
        ];
        text = ''
          # Read brightness value
          value=$(brightnessctl -m | cut -d, -f3)

          # Don't start if 0 brightness
          if [ "$value" -gt 0 ]; then
            ${pkgs.swaylock}/bin/swaylock --daemonize
          fi
        '';
      };

      # lock = "${pkgs.swaylock}/bin/swaylock --daemonize"; # Default
      lock = "${lib.getExe conditional_lock}";
      suspend = "systemctl suspend";

      conditional_display = pkgs.writeShellApplication {
        name = "conditional_lock";
        runtimeInputs = [
          pkgs.niri
          pkgs.brightnessctl
          pkgs.coreutils
          pkgs.gnused
        ];
        text = ''
          	status=$1 # First argument is "on" or "off"

           # Read brightness value
            value=$(brightnessctl -m | cut -d, -f3)

            # Don't start if 0 brightness
            if [ "$value" -gt 0 ]; then
              ${pkgs.niri}/bin/niri msg action power-"$status"-monitors
            fi
        '';
      };

      # display = status: "${pkgs.niri}/bin/niri msg action power-${status}-monitors"; # Default
      display = status: "${lib.getExe conditional_display} ${status}";
    in
    {
      enable = true;
      events = {
        before-sleep = (display "off") + "; " + lock;
        after-resume = display "on";
        lock = (display "off") + "; " + lock;
        unlock = display "on";
      };
      timeouts = [
        {
          timeout = 600; # 10 minutes
          command = lock;
        }
        {
          timeout = 300; # 5 minutes
          command = display "off";
          resumeCommand = display "on";
        }
        {
          timeout = 1200; # 20 minutes
          command = suspend;
        }
      ];
    };
}
