{ pkgs, ... }:

{
  services.gnome.gnome-keyring.enable = true;

  # Interface with X11 apps
  programs.xwayland.enable = true;

  # Attempt to open compatible apps with Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Tiling window manager
  programs.niri.enable = true;
  services.iio-niri.enable = true; # Allow screen rotation with Niri

  # # Desktop shell
  # services.displayManager.dms-greeter = {
  #   enable = true;
  #   compositor.name = "niri";
  # };
  # programs.dms-shell = {
  #   enable = true;
  #   enableVPN = false;
  #   enableAudioWavelength = false;
  # };

  # Enable terminal, launcher, and screen lock for Niri
  environment.systemPackages = with pkgs; [
    alacritty
    fuzzel
    swaylock
  ];

  # Use sane scrolling config
  services.libinput = {
    enable = true;
    touchpad.naturalScrolling = false;
    mouse.naturalScrolling = false;
  };
}
