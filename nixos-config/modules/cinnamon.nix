{ ... }:

{
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

  # services.xserver.desktopManager.cinnamon.settings.naturalScrolling = true;

  # Enable touchpad support with natural scrolling
  # services.libinput.enable = true;
  # services.libinput.touchpad.naturalScrolling = true; # ! Not working

  # # Enable dconf to manage Cinnamon settings
  # programs.dconf.enable = true;

  # # Install the Mint-Y themes package
  # environment.systemPackages = with pkgs; [
  #   mint-themes
  #   mint-y-icons
  #   dconf
  # ];

  # # === Direct dconf configuration ===
  # # This runs once when the system builds
  # system.activationScripts.set-cinnamon-theme = {
  #   text = ''
  #     # Create dconf database if it doesn't exist
  #     if [ -f /etc/dconf/db/local.d/00-cinnamon-settings ]; then
  #       echo "Cinnamon theme already configured in dconf"
  #     else
  #       echo "Setting Cinnamon theme to Mint-Y-Dark-Blue..."
        
  #       # Create the dconf settings file
  #       mkdir -p /etc/dconf/db/local.d
  #       cat > /etc/dconf/db/local.d/00-cinnamon-settings << 'EOF'
  #       [org/cinnamon/desktop/interface]
  #       gtk-theme='Mint-Y-Dark-Blue'
  #       icon-theme='Mint-Y-Dark-Blue'
  #       cursor-theme='Mint-Y-Dark-Blue'

  #       [org/cinnamon/desktop/wm/preferences]
  #       theme='Mint-Y-Dark-Blue'

  #       [org/cinnamon/theme]
  #       name='Mint-Y-Dark-Blue'
  #       EOF
              
  #       # Update dconf database
  #       ${pkgs.dconf}/bin/dconf update
  #     fi
  #   '';
  # };
}
