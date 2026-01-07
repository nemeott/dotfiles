{
  stdenv,
  lib,
  fetchurl,
  unzip,
  appimageTools,
  undmg,
  ...
}:

let
  pname = "musescore-evolution";
  buildNumber = "260106044";
  version = "3.7.0-evo.${buildNumber}";

  baseUrl = "https://github.com/nemeott/MuseScore-Evolution-Builds/releases/download";

  zipName = suffix: "Mu3.7_${buildNumber}_${suffix}.zip";

  mkUrl = suffix: "${baseUrl}/v${version}/${zipName suffix}";

  srcs = {
    "x86_64-linux" = fetchurl {
      url = mkUrl "Lin_x86_64_3.x";
      sha256 = "sha256-strCfimgBdGNjTYM3A4fmopRhOACSZwCAEntnGdoRQU=";
    };
    "aarch64-linux" = fetchurl {
      url = mkUrl "Lin_aarch64_3.x";
      sha256 = "sha256-ovFpi/bdzSOJOc+6Cvhz9vVqAXFSIa7hyfIEv5/Qpjw=";
    };
    "armv7l-linux" = fetchurl {
      url = mkUrl "Lin_armv7l_3.x";
      sha256 = "sha256-uOmdP7ynm5keqDpiqqoLgqGyfg20z3VL77K+DnCCAh0=";
    };
    "x86_64-darwin" = fetchurl {
      url = mkUrl "Mac_3.x_Intel";
      sha256 = "sha256-lVaWr81RHn+H4lvV9088/2L+qem8Y2a2V/KPMmmRHAE=";
    };
    "aarch64-darwin" = fetchurl {
      url = mkUrl "Mac_3.x_Apple";
      sha256 = "sha256-GzgrUx/wDLoy4jv+jPRG0zKxxG5Jt1lSNXazsQajZK8=";
    };
  };

  zipSrc =
    srcs.${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  metaCommon = {
    description = "Music notation and composition software";
    homepage = "https://github.com/Jojo-Schmitz/MuseScore";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ nemeott ];
    mainProgram = "mscore-evo";
  };

  # Linux: extract AppImage and wrap it
  appimage = stdenv.mkDerivation {
    pname = "${pname}-appimage";
    inherit version;

    src = zipSrc;

    # Unpack manually
    dontUnpack = true;
    nativeBuildInputs = [ unzip ];

    installPhase = ''
      mkdir -p "$out"
      # Extract only the AppImage from the zip archive
      unzip "$src" '*.AppImage'

      # Normalize the AppImage name and move it to $out
      appimage=$(find . -maxdepth 1 -type f -name '*.AppImage' | head -n 1)
      if [ -z "$appimage" ]; then
        echo "Error: No AppImage found in the zip archive" >&2
        echo "Contents of current directory:" >&2
        ls -R >&2
        exit 1
      fi
      cp "$appimage" "$out/${pname}.AppImage"
    '';
  };

  # macOS: unzip DMG and extract .app
  dmgApp = stdenv.mkDerivation {
    pname = pname;
    inherit version;

    src = zipSrc;

    # Unpack manually
    dontUnpack = true;
    nativeBuildInputs = [
      unzip
      undmg
    ];

    installPhase = ''
      mkdir -p "$out/Applications" "$out/bin"

      unzip "$src"

      dmg=$(find . -maxdepth 1 -type f -name '*.dmg' | head -n 1)
      if [ -z "$dmg" ]; then
        echo "Error: No DMG found in the zip archive" >&2
        echo "Contents of current directory:" >&2
        ls -R >&2
        exit 1
      fi

      undmg "$dmg"

      app=$(find . -maxdepth 1 -type d -name '*.app' | head -n 1)
      if [ -z "$app" ]; then
        echo "Error: No .app found in the DMG" >&2
        echo "Contents of current directory:" >&2
        ls -R >&2
        exit 1
      fi

      cp -r "$app" "$out/Applications/"

      bin=$(find "$out/Applications" -path '*Contents/MacOS/*' -type f | head -n 1)
      if [ -z "$bin" ]; then
        echo "Error: No executable found inside the .app" >&2
        echo "Contents of .app:" >&2
        ls -R "$out/Applications" >&2
        exit 1
      fi

      ln -s "$bin" "$out/bin/mscore-evo"
    '';
  };
in
if stdenv.hostPlatform.isLinux then
  appimageTools.wrapType2 {
    inherit pname version;
    src = "${appimage}/${pname}.AppImage";

    meta = metaCommon // {
      platforms = [
        "x86_64-linux"
        "aarch64-linux"
        "armv7l-linux"
      ];
    };
  }
else if stdenv.hostPlatform.isDarwin then
  dmgApp
  // {
    meta = metaCommon // {
      platforms = [
        "x86_64-darwin"
        "aarch64-darwin"
      ];
    };
  }
else
  throw "Unsupported platform: ${stdenv.hostPlatform.system}"
