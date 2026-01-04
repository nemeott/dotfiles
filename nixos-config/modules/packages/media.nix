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
  ];
}
