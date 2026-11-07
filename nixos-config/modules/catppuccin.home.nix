{ lib, pkgs, ... }:

{
  gtk =
    let
      catppuccin-theme = {
        name = "catppuccin-mocha-mauve-standard";
        package = pkgs.catppuccin-gtk.override {
          variant = "mocha";
          accents = [ "mauve" ];
        };
      };
    in
    {
      enable = true;

      theme = catppuccin-theme;
      gtk3.theme = catppuccin-theme;
      gtk4.theme = catppuccin-theme;
      iconTheme = lib.mkForce {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
      # Already applied in Niri
      cursorTheme = {
        name = "Bibata-Modern-Classic";
        package = pkgs.bibata-cursors;
      };
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = true;
      };
    };

  # HM keeps complaining about gtk.css.backup file being replaced even though the contents are the same
  home.activation.removeGtkBackup = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    rm -f "$HOME/.config/gtk-4.0/gtk.css.backup"
  '';
}
