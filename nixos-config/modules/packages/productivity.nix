{ pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    obsidian
    # libreoffice-stable
    # onlyoffice-desktopeditors
    (inputs.onlyoffice4nixos.packages.x86_64-linux.onlyoffice-desktopeditors.override {
      extraFontPackages = with pkgs; [
        ubuntu-classic
        ubuntu-sans
        noto-fonts
        liberation_ttf

        monaspace
      ];
    })
    kdePackages.okular # PDF viewer
    # pdfsam-basic # Edit PDFs
  ];
}
