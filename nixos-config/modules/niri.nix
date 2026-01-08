{ lib, pkgs, ... }:

{
  # Tiling window manager
  programs.niri.enable = true;

  # Desktop shell
  services.displayManager.dms-greeter = {
    enable = true;
    compositor.name = "niri";
  };
  programs.dms-shell.enable = true;
}
