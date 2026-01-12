{
  pkgs,
  noctalia,
  username,
  ...
}:

{
  # Interface with X11 apps
  programs.xwayland.enable = true;

  # Attempt to open compatible apps with Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services.greetd = {
    enable = true;
    # settings.default_session = {
    #   command = "niri --config /home/${username}/.config/niri/config.kdl";
    #   user = "${username}";
    # };
    settings = {
      default_session.command = "${pkgs.tuigreet}/bin/tuigreet -t --time-format '%F %H:%M:%S' --remember --remember-user-session --asterisks --asterisks-char '◆' --window-padding 2";
    };
  };
  # programs.regreet.enable = true;

  # Tiling window manager
  programs.niri.enable = true;
  services.iio-niri.enable = true; # Allow screen rotation with Niri

  services.libinput.enable = true;
  services.xserver.exportConfiguration = true;

  # Enable terminal, launcher, and screen lock for Niri
  environment.systemPackages = with pkgs; [
    xwayland-satellite # X11 compatibility for Wayland
    noctalia.packages.${stdenv.hostPlatform.system}.default # Bar

    alacritty
    fuzzel
    swaylock
  ];
}
