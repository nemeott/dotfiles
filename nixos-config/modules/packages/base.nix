{ pkgs, ... }:

{
  programs.bash.enable = true; # Installed by default, but just in case
  programs.nano.enable = true; # Installed by default, but just in case
  programs.git.enable = true;

  environment.systemPackages = with pkgs; [
    # Basics
    wget
    curl

    # Hardware
    pciutils
    file

    # Archiving / transfer
    unzip
    zip
    gnutar
    rsync

    # Networking
    openssh
    openssl
  ];
}
