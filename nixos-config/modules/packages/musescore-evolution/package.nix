# cd ~/dotfiles
# nix-build -E 'with import <nixpkgs> {}; callPackage ./nixos-config/modules/packages/musescore-evolution/package.nix {}'

# ls -l result/bin
# ./result/bin/mscore-evolution

{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  wrapGAppsHook3,
  pkg-config,
  ninja,
  alsa-lib,
  alsa-plugins,
  freetype,
  libjack2,
  lame,
  libogg,
  libpulseaudio,
  libsndfile,
  libvorbis,
  portaudio,
  portmidi,
  flac,
  libopusenc,
  libopus,
  tinyxml-2,
  kdePackages,
  qt5, # Needed for musescore 3.X
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "musescore-evolution";
  version = "3.7.0";

  # nix run nixpkgs#nix-prefetch-git -- https://github.com/Jojo-Schmitz/MuseScore.git 44b8c262e47864109e1a773a3bdb4e40b4759f9d
  src = fetchFromGitHub {
    owner = "Jojo-Schmitz";
    repo = "MuseScore";
    rev = "44b8c262e47864109e1a773a3bdb4e40b4759f9d";
    sha256 = "sha256-pG5CfEvgff48l7OMPEqmYW0EVSROh55bc+K5VZMzCVA=";
  };

  # From top-level CMakeLists.txt:
  # - DOWNLOAD_SOUNDFONT defaults ON and tries to fetch from the network.
  cmakeFlags = [
    "-DDOWNLOAD_SOUNDFONT=OFF"
  ];

  qtWrapperArgs = [
    # MuseScore JACK backend loads libjack at runtime.
    "--prefix ${lib.optionalString stdenv.hostPlatform.isDarwin "DY"}LD_LIBRARY_PATH : ${
      lib.makeLibraryPath [ libjack2 ]
    }"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux) [
    "--set ALSA_PLUGIN_DIR ${alsa-plugins}/lib/alsa-lib"
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    # There are some issues with using the wayland backend, see:
    # https://musescore.org/en/node/321936
    "--set-default QT_QPA_PLATFORM xcb"
  ];

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  dontWrapGApps = true;

  nativeBuildInputs = [
    qt5.wrapQtAppsHook
    cmake
    qt5.qttools
    pkg-config
    ninja
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    # Since https://github.com/musescore/MuseScore/pull/13847/commits/685ac998
    # GTK3 is needed for file dialogs. Fixes crash with No GSettings schemas error.
    wrapGAppsHook3
  ];

  buildInputs = [
    libjack2
    freetype
    lame
    libogg
    libpulseaudio
    libsndfile
    libvorbis
    portaudio
    portmidi
    flac
    libopusenc
    libopus
    tinyxml-2
    qt5.qtbase
    qt5.qtdeclarative
    qt5.qtsvg
    qt5.qtxmlpatterns
    qt5.qtquickcontrols2
    qt5.qtgraphicaleffects
    # qt5.qtwebengine # Avoid depending on insecure QtWebEngine (and having to compile qt5.qtwebengine (huge))
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
  ];

  postPatch = ''
    # Disable Qt bundling logic in the source CMakeLists.
    if [ -f main/CMakeLists.txt ]; then
      sed -i '/QT_INSTALL_PREFIX/d' main/CMakeLists.txt
      sed -i '/QtWebEngineProcess/d' main/CMakeLists.txt
    fi
  '';

  # Patch the generated install script to drop Qt resource / QtWebEngine installs.
  preInstall = ''
    if [ -f main/cmake_install.cmake ]; then
      sed -i '
        /QtWebEngineProcess/d
        /resources\"/d
        /qtwebengine_locales/d
        /qtwebengine/d
        /QT_INSTALL_PREFIX/d
      ' main/cmake_install.cmake
    fi
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p "$out/Applications"
    mv "$out/mscore.app" "$out/Applications/mscore-evolution.app"
    mkdir -p $out/bin
    ln -s $out/Applications/mscore-evolution.app/Contents/MacOS/mscore $out/bin/mscore-evolution
  '';

  # On Linux, let CMake + wrapQtAppsHook install/wrap "mscore", then rename it
  # so it does not clash with the main musescore package.
  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    if [ -x "$out/bin/mscore" ]; then
      mv "$out/bin/mscore" "$out/bin/mscore-evolution"
    fi
  '';

  # Don't run bundled upstreams tests, as they require a running X window system.
  doCheck = false;

  # passthru.tests = nixosTests.musescore;
  passthru.tests = { };

  meta = {
    description = "Music notation and composition software";
    homepage = "https://github.com/Jojo-Schmitz/MuseScore";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "mscore-evolution";
    platforms = lib.platforms.unix;
  };
})
