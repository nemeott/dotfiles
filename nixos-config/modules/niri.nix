{ pkgs, ... }:

{
  # Name the generation
  system.nixos.tags = [ "Niri" ];

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

  environment.systemPackages = with pkgs; [
    xwayland-satellite # X11 compatibility for Wayland
  ];
}
