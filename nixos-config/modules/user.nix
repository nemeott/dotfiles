{ pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  security.sudo.wheelNeedsPassword = false; # Allow sudo without password for wheel group
  users.users.nathan = {
    isNormalUser = true;
    description = "Nathan";
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio" # Add user to audio group to allow sound control
    ];
    packages = with pkgs; [

    ];
  };
}
