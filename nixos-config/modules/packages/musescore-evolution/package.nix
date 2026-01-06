{ musescore, fetchFromGitHub, ... }:

musescore.overrideAttrs (oldAttrs: rec {
  pname = "musescore-evolution";
  version = "3.7.0";

  # nix run nixpkgs#nix-prefetch-git -- https://github.com/Jojo-Schmitz/MuseScore.git 44b8c262e47864109e1a773a3bdb4e40b4759f9d
  src = fetchFromGitHub {
    owner = "Jojo-Schmitz";
    repo = "MuseScore";
    rev = "44b8c262e47864109e1a773a3bdb4e40b4759f9d";
    sha256 = "sha256-pG5CfEvgff48l7OMPEqmYW0EVSROh55bc+K5VZMzCVA=";
  };

  # Don't need patches anymore since the CMakeLists.txt has changed
  patches = [ ];

  postFixup = (oldAttrs.postFixup or "") + ''
    # Rename binary so it doesn't conflict with pkgs.musescore
    if [ -x "$out/bin/musescore" ]; then
      mv "$out/bin/musescore" "$out/bin/musescore-evolution"
    fi

    # Fix .desktop file(s) to use the new binary and name
    if [ -d "$out/share/applications" ]; then
      for f in "$out"/share/applications/*.desktop; do
        substituteInPlace "$f" \
          --replace "Exec=musescore" "Exec=musescore-evolution" \
          --replace "Name=MuseScore 3" "Name=MuseScore Evolution"
      done
    fi
  '';
})
