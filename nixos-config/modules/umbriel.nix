{ inputs, pkgs, ... }:

{
  imports = [ inputs.umbriel.nixosModules.default ];

  nix.settings = {
    extra-substituters = [ "https://umbriel.cachix.org" ];
    extra-trusted-public-keys = [
      "umbriel.cachix.org-1:JfNq/2yg2S6D6z4Z2dVSZrZlDPQTKtexB6GAVLD98nw="
    ];
  };

  # Name the generation
  system.nixos.tags = [ "Umbriel" ];

  # Window manager
  programs.umbriel.enable = true;

  # TODO: Fork and make work with Umbriel
  # # Allow screen rotation with Niri
  # services.iio-niri = {
  #   enable = true;
  #   extraArgs = [ "--lock-rotation" ];
  # };

  # TODO: Probably not needed

  # # Interface with X11 apps
  # programs.xwayland.enable = true;

  # # Attempt to open compatible apps with Wayland
  # environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # environment.systemPackages = with pkgs; [
  #   xwayland-satellite # X11 compatibility for Wayland
  # ];
}
