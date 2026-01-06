{
  mkDerivation,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  alsa-lib,
  freetype,
  libjack2,
  lame,
  libogg,
  libpulseaudio,
  libsndfile,
  libvorbis,
  portaudio,
  portmidi,
  qtbase,
  qtdeclarative,
  qtgraphicaleffects,
  qtquickcontrols2,
  qtscript,
  qtsvg,
  qttools,
  qtwebengine,
  qtxmlpatterns,
  nixosTests,
}:

mkDerivation rec {
  pname = "musescore-evolution";
  version = "3.7.0";

  # nix run nixpkgs#nix-prefetch-git -- https://github.com/Jojo-Schmitz/MuseScore.git 44b8c262e47864109e1a773a3bdb4e40b4759f9d
  src = fetchFromGitHub {
    owner = "Jojo-Schmitz";
    repo = "MuseScore";
    rev = "44b8c262e47864109e1a773a3bdb4e40b4759f9d";
    sha256 = "sha256-pG5CfEvgff48l7OMPEqmYW0EVSROh55bc+K5VZMzCVA=";
  };

  # patches = [
  #   ./remove_qtwebengine_install_hack.patch
  # ];

  cmakeFlags = [
    "-DMUSESCORE_BUILD_CONFIG=release"
    "-DUSE_SYSTEM_FREETYPE=ON"
  ];

  qtWrapperArgs = [
    # MuseScore JACK backend loads libjack at runtime.
    "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libjack2 ]}"
    # There are some issues with using the wayland backend, see:
    # https://musescore.org/en/node/321936
    "--set-default QT_QPA_PLATFORM xcb"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    libjack2
    freetype
    lame
    libogg
    libpulseaudio
    libsndfile
    libvorbis
    portaudio
    portmidi # tesseract
    qtbase
    qtdeclarative
    qtgraphicaleffects
    qtquickcontrols2
    qtscript
    qtsvg
    qttools
    qtwebengine
    qtxmlpatterns
  ];

  passthru.tests = nixosTests.musescore;

  meta = with lib; {
    description = "Music notation and composition software";
    homepage = "https://github.com/Jojo-Schmitz/MuseScore";
    license = licenses.gpl2;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
