{
  pkgs,
  noctalia,
  ...
}:

{
  # Name the generation
  system.nixos.tags = [ "Niri" ];

  # Interface with X11 apps
  programs.xwayland.enable = true;

  # Attempt to open compatible apps with Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services.greetd = {
    enable = true;
    settings = {
      default_session.command = "${pkgs.tuigreet}/bin/tuigreet -t --time-format '%F %H:%M:%S' --remember --remember-user-session --asterisks --asterisks-char '◆' --window-padding 2";
    };
  };

  # Tiling window manager
  programs.niri.enable = true;
  services.iio-niri.enable = true; # Allow screen rotation with Niri

  catppuccin.enable = true;
  catppuccin.tty.enable = false; # Save my eyes on boot

  # services.libinput.enable = true;
  # services.xserver.exportConfiguration = true;

  # Enable terminal, launcher, and screen lock for Niri
  environment.systemPackages = with pkgs; [
    xwayland-satellite # X11 compatibility for Wayland
    noctalia.packages.${stdenv.hostPlatform.system}.default # Bar

    brightnessctl
    # Custom brightness control scripts (0, 1, 5, 10, ...)
    (writeShellApplication {
      name = "brightness_down";
      runtimeInputs = [ brightnessctl ];
      text = ''
        	      p=$(brightnessctl -m | cut -d, -f4 | sed 's/%//')
                if [ "$p" -le 1 ]; then
                    brightnessctl --class=backlight set 0%
                elif [ "$p" -le 5 ]; then
                    brightnessctl --class=backlight set 1%
                else
                    brightnessctl --class=backlight set 5%-
                fi
      '';
    })
    (writeShellApplication {
      name = "brightness_up";
      runtimeInputs = [ brightnessctl ];
      text = ''
        			p=$(brightnessctl -m | cut -d, -f4 | sed 's/%//')
        			if [ "$p" -eq 0 ]; then
        		  brightnessctl --class=backlight set 1%
        			elif [ "$p" -eq 1 ]; then
        		  brightnessctl --class=backlight set 5%
        			else
        		  brightnessctl --class=backlight set +5%
        			fi
      '';
    })

    bibata-cursors
    papirus-icon-theme
    adwaita-icon-theme

    # Media
    nemo-with-extensions # File manager
    pix # Image viewer
  ];

  # environment.variables = {
  #   XDG_ICON_THEME = "Papirus";
  # };
}
