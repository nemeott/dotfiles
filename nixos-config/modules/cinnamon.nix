{
  lib,
  pkgs,
  catppuccin,
  ...
}:

{
  imports = [ catppuccin.nixosModules.catppuccin ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the Cinnamon Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.cinnamon.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Use sane scrolling config
  services.libinput = {
    enable = true;

    # Want to set this in dconf (org/cinnamon/desktop/peripherals/touchpad)
    touchpad.naturalScrolling = false; # ! Not working
    mouse.naturalScrolling = false; # org/gnome/desktop/peripherals/mouse
  };
  
  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "mauve";
  };

  # dconf dump | cat

  # Set base theme in org/cinnamon/theme
  # name='Mint-Y-Dark-Blue'

  # Set theme in org/cinnamon/desktop/interface
  # cursor-theme='Bibata-Modern-Classic'
  # gtk-theme='Mint-Y-Dark-Blue'
  # icon-theme='Mint-Y-Blue'

  # Disable sounds in org/cinnamon/sounds
  # login-enabled=false
  # logout-enabled=false
  # plug-enabled=false
  # switch-enabled=false
  # tile-enabled=false
  # unplug-enabled=false

  # org/gnome/desktop/interface
  # cursor-theme='Bibata-Modern-Classic'
  # gtk-theme='Mint-Y-Dark-Blue'
  # icon-theme='Mint-Y-Blue'
}
