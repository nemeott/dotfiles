{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    obsidian
    libreoffice-fresh
    onlyoffice-desktopeditors
    kdePackages.okular # PDF viewer
    pdfsam-basic # Edit PDFs
  ];
}
