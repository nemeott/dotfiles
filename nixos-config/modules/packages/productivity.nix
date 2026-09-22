{ pkgs, ... }:

{
  programs.onlyoffice.enable = true;

  environment.systemPackages = with pkgs; [
    obsidian
    libreoffice-stable
    # onlyoffice-desktopeditors
    kdePackages.okular # PDF viewer
    # pdfsam-basic # Edit PDFs
  ];
}
