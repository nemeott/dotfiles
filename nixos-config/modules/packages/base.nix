{ pkgs, ... }:

{
  programs.bash.enable = true; # Installed by default, but just in case
  home.file.".bashrc".source = ../../../.bashrc;
  home.file.".bash_aliases".source = ../../../.bash_aliases;

  programs.nano.enable = true; # Installed by default, but just in case

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
    rsync

    # Networking
    openssh
    openssl
  ];
}
