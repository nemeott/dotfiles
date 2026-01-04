{ pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.daedalus = {
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
