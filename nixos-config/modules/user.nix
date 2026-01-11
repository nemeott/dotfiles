{ lib, username, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  security.sudo.wheelNeedsPassword = false; # Allow sudo without password for wheel group
  users.users.${username} = {
    isNormalUser = true;
    description = lib.strings.toCamelCase username;
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio" # Add user to audio group to allow sound control
    ];
    packages = [ ];
  };
}
