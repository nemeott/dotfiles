{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Editor / basics
    nano
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