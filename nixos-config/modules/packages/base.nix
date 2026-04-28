{ pkgs, ... }:

{
  programs = {
    bash.enable = true; # Installed by default, but just in case
    nano.enable = true; # Installed by default, but just in case
  };
  environment.systemPackages = with pkgs; [
    # Basics
    wget
    curl
    git # Enabled in dev.nix but here for base system

    # Hardware
    pciutils
    file

    # Archiving / transfer
    unzip
    zip
    gnutar
    p7zip
    rsync

    # Networking
    openssh
    openssl
  ];
}
