{ pkgs, ... }:

{
  programs = {
    bash.enable = true; # Installed by default, but just in case
    nano.enable = true; # Installed by default, but just in case
    
    ssh.startAgent = true; # Don't need to type password for every ssh connection
    # TODO: enableAskPassword? (https://wiki.nixos.org/wiki/SSH_public_key_authentication)
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
