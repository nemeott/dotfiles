{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Editor / basics
    bash # (installed by default, but just in case)
    nano # (installed by default, but just in case)
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