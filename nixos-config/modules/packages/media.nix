{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Media players
    vlc

    # Camera
    cheese

    # CLI media tools
    ffmpeg
    imagemagick

    # Image viewer
    vipsdisp

    # Color picker
    wl-color-picker

    # Media editing
    gimp # Image editor
    siril # Astrophotographic image processing tool
    # aseprite # Pixel art editor and animator
    audacity # Audio editor

    # Music
    musescore
    muse-sounds-manager
    musescore-evolution # MuseScore 3.7 evolution (fork of musescore 3.6.2 with various fixes)
  ];
}
