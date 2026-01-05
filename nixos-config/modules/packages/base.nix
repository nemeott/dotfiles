{ pkgs, ... }:

{
  programs.bash.enable = true; # Installed by default, but just in case
  programs.nano.enable = true; # Installed by default, but just in case

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
