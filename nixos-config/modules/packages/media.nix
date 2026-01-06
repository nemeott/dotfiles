{ pkgs, ... }:

let
  musescore-evolution = pkgs.callPackage ./musescore-evolution.nix {
    mkDerivation = pkgs.libsForQt5.mkDerivation;
    nixosTests = pkgs.nixosTests;

    # Provide Qt5 deps (they’re not top-level pkgs.* on many channels)
    qtbase = pkgs.libsForQt5.qtbase;
    qtdeclarative = pkgs.libsForQt5.qtdeclarative;
    qtgraphicaleffects = pkgs.libsForQt5.qtgraphicaleffects;
    qtquickcontrols2 = pkgs.libsForQt5.qtquickcontrols2;
    qtscript = pkgs.libsForQt5.qtscript;
    qtsvg = pkgs.libsForQt5.qtsvg;
    qttools = pkgs.libsForQt5.qttools;
    qtwebengine = pkgs.libsForQt5.qtwebengine;
    qtxmlpatterns = pkgs.libsForQt5.qtxmlpatterns;
  };
in
{
  nixpkgs.config.permittedInsecurePackages = [
    "qtwebengine-5.15.19"
  ];

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
