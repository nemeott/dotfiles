{ inputs, pkgs, ... }:

# Toggle iio-niri screen rotation
let
  toggle_screen_rotation = pkgs.writeShellApplication {
    name = "toggle_screen_rotation";
    runtimeInputs = [ pkgs.systemd ];
    text = ''
      if systemctl --user is-active --quiet iio-niri; then
          systemctl --user stop iio-niri
      else
          systemctl --user start iio-niri
      fi
    '';
  };
in
{
  imports = [ inputs.catppuccin.nixosModules.catppuccin ];

  # Name the generation
  system.nixos.tags = [ "Niri" ];

  # Interface with X11 apps
  programs.xwayland.enable = true;

  # Attempt to open compatible apps with Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services.greetd = {
    enable = true;
    settings = {
      default_session.command = "${pkgs.tuigreet}/bin/tuigreet -t --time-format '%F %H:%M:%S' --remember --remember-user-session --asterisks --asterisks-char '*' --window-padding 2";
    };
    useTextGreeter = true;
  };

  # Use swaylock for authentication
  security.pam.services.swaylock = { };

  # Tiling window manager
  programs.niri.enable = true;
  services.iio-niri.enable = true; # Allow screen rotation with Niri

  catppuccin.enable = true;
  catppuccin.tty.enable = false; # Save my eyes on boot

  environment.systemPackages = with pkgs; [
    xwayland-satellite # X11 compatibility for Wayland
    nirimod # GUI for managing Niri
    inputs.noctalia.packages.${stdenv.hostPlatform.system}.default # Bar
    cliphist
    wl-clipboard

    brightnessctl
    # Custom brightness control scripts (0%, 1, 1%, 5%, 10%, ...)
    (writeShellApplication {
      name = "brightness_down";
      runtimeInputs = [ brightnessctl ];
      text = ''
        value=$(brightnessctl -m | cut -d, -f3 | sed 's/%//')
        percent=$(brightnessctl -m | cut -d, -f4 | sed 's/%//')
        if [ "$value" -le 1 ]; then
            brightnessctl --class=backlight set 0%
            echo 1 | tee /sys/class/backlight/intel_backlight/bl_power
        elif [ "$percent" -le 1 ]; then
            brightnessctl --class=backlight set 1
        elif [ "$percent" -le 5 ]; then
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
        value=$(brightnessctl -m | cut -d, -f3 | sed 's/%//')
        percent=$(brightnessctl -m | cut -d, -f4 | sed 's/%//')
        if [ "$value" -eq 0 ]; then
            echo 0 | tee /sys/class/backlight/intel_backlight/bl_power
            brightnessctl --class=backlight set 1
        elif [ "$value" -eq 1 ]; then
            brightnessctl --class=backlight set 1%
        elif [ "$percent" -eq 1 ]; then
            brightnessctl --class=backlight set 5%
        else
            brightnessctl --class=backlight set +5%
        fi
      '';
    })

    toggle_screen_rotation

    bibata-cursors
    papirus-icon-theme # TODO: Actually use these
    adwaita-icon-theme

    # Media
    nemo-with-extensions # File manager
    pix # Image viewer
  ];

  systemd.user.services.disable-rotation-on-startup = {
    description = "Disable iio-niri screen rotation on startup";

    wantedBy = [ "niri.service" ];
    after = [
      "niri.service"
      "iio-niri.service"
    ];
    serviceConfig.Type = "oneshot";

    # Let quickshell initialize, then turn off rotation
    script = ''
      ${toggle_screen_rotation}/bin/toggle_screen_rotation
    '';
  };

  # environment.variables = {
  #   XDG_ICON_THEME = "Papirus";
  # };
}
