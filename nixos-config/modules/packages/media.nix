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

    # Media editing
    gimp
    audacity

    # Music
    musescore
    muse-sounds-manager
  ];
}
