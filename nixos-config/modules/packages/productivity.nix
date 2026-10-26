{ pkgs, ... }:

{
  programs.onlyoffice = {
    enable = true;
    extraFontPackages = with pkgs; [
      ubuntu-classic
      ubuntu-sans
      noto-fonts
      liberation_ttf

      monaspace
    ];
  };

  environment.systemPackages = with pkgs; [
    obsidian
    # libreoffice-stable

    kdePackages.okular # PDF viewer
    # pdfsam-basic # Edit PDFs
  ];
}
