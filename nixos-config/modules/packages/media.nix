{ pkgs, lib, ... }:

let
  siril-wrapped = pkgs.symlinkJoin {
    name = "siril";
    paths = [ pkgs.siril ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    # Add libraries to path for Python scripts
    postBuild = with pkgs; ''
      wrapProgram $out/bin/siril \
        --prefix LD_LIBRARY_PATH : ${
          lib.makeLibraryPath [
            # NumPy
            stdenv.cc.cc.lib # libstdc++
            zlib # libz
            # PyQt6 (auto gradient removal script)
            zstd # libzstd
            brotli # libbrotlidec
            dbus # libdbus-1
            libdrm # libdrm
            libGL # libGL, libEGL
            fontconfig # libfontconfig
            freetype # libfreetype
            glib # libglib-2.0, libgthread-2.0
            krb5 # libgssapi_krb5
            wayland # libwayland-client, libwayland-cursor
            libxkbcommon # libxkbcommon, libxkbcommon-x11
            libX11 # libX11, libX11-xcb
            libxcb # libxcb.so.1 + libxcb-glx/randr/render/shape/shm/sync/xfixes/xkb
            xcbutil # libxcb-util
            xcbutilcursor # libxcb-cursor (nixpkgs name; xcb-util-cursor is an alias)
            xcbutilimage # libxcb-image
            xcbutilkeysyms # libxcb-keysyms
            xcbutilrenderutil # libxcb-render-util
            xcbutilwm # libxcb-icccm
            # # GraXpert
            # libXrender # libXrender

          ]
        }
    '';
  };
  
  graxpert-wrapped = pkgs.writeShellScriptBin "graxpert" ''
    exec ${pkgs.steam-run}/bin/steam-run /home/nathan/Pictures/Astrophotography/Siril/GraXpert-linux-3.1.0rc2/GraXpert "$@"
  '';
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

    # Image viewer
    vipsdisp

    # Color picker
    wl-color-picker

    # Media editing
    gimp-with-plugins # Image editor (gmic, lighting, resynthisizer)
    siril-wrapped # Astrophotographic image processing tool
    graxpert-wrapped # Astrophotograpic background remover
    # python313Packages.tkinter # For GraXpert
    # aseprite # Pixel art editor and animator
    audacity # Audio editor

    # Music
    musescore
    muse-sounds-manager
    musescore-evolution # MuseScore 3.7 evolution (fork of musescore 3.6.2 with various fixes)
  ];

  # For StarNet binary used in Siril
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      # StarNet binary
      stdenv.cc.cc.lib
      zlib
    ];
  };
}
