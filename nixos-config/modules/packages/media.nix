{ pkgs, ... }:

let
  musescore-evolution = pkgs.callPackage ./musescore-evolution/package-scratch.nix { };
  # musescore-evolution = pkgs.callPackage ./musescore-evolution/package.nix { };
in
{
  environment.systemPackages = with pkgs; [
    # Media players
    vlc

    # Camera
    cheese

    # CLI media tools
    ffmpeg
    imagemagick

    # Media editing
    gimp
    audacity

    # Music
    musescore
    muse-sounds-manager
    musescore-evolution # MuseScore 3.7 evolution (fork of musescore 3.6.2 with various fixes)
  ];
}
