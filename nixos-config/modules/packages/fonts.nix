{ pkgs, ... }:

{
  fonts = {
    # enableDefaultPackages = true; # Install some basic fonts for better Unicode coverage
    packages = with pkgs; [
      ubuntu-classic
      ubuntu-sans
      noto-fonts
      liberation_ttf

      monaspace
      # (monaspace.overrideAttrs (o: {
      #   nativeBuildInputs = [ pkgs.nerd-font-patcher ];
      #   postInstall = ''
      #     mkdir -p $out/share/fonts/truetype/{monaspace,monaspace-nerd}
      #     mv $out/share/fonts/truetype/*.ttf $out/share/fonts/truetype/monaspace/
      #     for f in $out/share/fonts/truetype/monaspace/*.ttf; do
      #       nerd-font-patcher --complete --outputdir $out/share/fonts/truetype/monaspace-nerd/ $f
      #     done
      #   '';
      # }))
      # nerd-fonts.monaspace
    ];
    fontconfig = {
      defaultFonts = {
        serif = [
          "Noto Serif"
          "Liberation Serif"
        ];
        sansSerif = [
          "Noto Sans"
          "Liberation Sans"
          "Ubuntu"
        ];
        monospace = [
          "Monaspace Neon Frozen" # Use ligatures by default
          "Monaspace Neon NF" # Fallback to include Nerd Fonts
        ];
      };
    };
  };
}
