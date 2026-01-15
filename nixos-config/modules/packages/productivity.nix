{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    obsidian
    libreoffice-fresh
    kdePackages.okular # PDF viewer
    pdfsam-basic # Edit PDFs
  ];
}
