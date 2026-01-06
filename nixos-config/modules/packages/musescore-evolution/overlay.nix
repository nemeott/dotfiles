self: super: {
  # Build MuseScore 3.6.2 with Qt5
  musescore3_6_2 = super.libsForQt5.callPackage ./musescore-3_6_2.nix { };

  # Evolution: 3.7 fork based on 3.6.2 packaging
  musescore-evolution = super.callPackage ./package.nix {
    musescore = self.musescore3_6_2;
  };
}
