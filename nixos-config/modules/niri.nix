{ inputs, pkgs, ... }:

{
  imports = [ inputs.catppuccin.nixosModules.catppuccin ];

  # Name the generation
  system.nixos.tags = [ "Niri" ];

  services.greetd = {
    enable = true;
    settings = {
      default_session.command = "${pkgs.tuigreet}/bin/tuigreet -t --time-format '%F %H:%M:%S' --remember --remember-user-session --asterisks --asterisks-char '*' --window-padding 2";
    };
    useTextGreeter = true;
  };

  # Hide audio error messages on the greeter
  systemd.services.suppress-console-noise = {
    description = "Suppress kernel console messages during greeter";
    wantedBy = [ "greetd.service" ];
    before = [ "greetd.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.util-linux}/bin/dmesg --console-level 1";
    };
  };

  security.pam = {
    # Use swaylock for authentication
    services.swaylock = { };

    # Allow any program run by users group to request real-time priority
    # Improves latency and reduces stuttering (https://wiki.nixos.org/wiki/Sway)
    loginLimits = [
      {
        domain = "@users";
        item = "rtprio";
        type = "-";
        value = 1;
      }
    ];
  };

  # Tiling window manager
  programs.niri.enable = true;

  # Allow screen rotation with Niri
  services.iio-niri = {
    enable = true;
    extraArgs = [ "--lock-rotation" ];
  };

  # Interface with X11 apps
  programs.xwayland.enable = true;

  # Attempt to open compatible apps with Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  catppuccin = {
    enable = true;
    autoEnable = true;
    tty.enable = false; # Save my eyes on boot
  };

  # Enable binary cache for Noctalia
  nix.settings = {
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  environment.systemPackages = with pkgs; [
    xwayland-satellite # X11 compatibility for Wayland
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

    bibata-cursors
    papirus-icon-theme # TODO: Actually use these
    adwaita-icon-theme

    # Media
    nemo-with-extensions # File manager
  ];

  # environment.variables = {
  #   XDG_ICON_THEME = "Papirus";
  # };
}
