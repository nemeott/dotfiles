{ username, ... }:

let
  dotfilesPath = ../../..;
in
{
  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.11";

    file.".bashrc".source = "${dotfilesPath}/.bashrc";
    file.".bash_aliases".source = "${dotfilesPath}/.bash_aliases";

    # file.".config/niri/config.kdl".source = "${dotfilesPath}/config.kdl";

    # # Greetd configuration to run regreet on startup
    # file.".config/niri/greetd.kdl".text = ''
    #   spawn-sh-at-startup "regreet; niri msg action quit --skip-confirmation"
    #   hotkey-overlay {
    #       skip-at-startup
    #   }
    #   cursor {
    #       xcursor-theme "catppuccin-mocha-red-cursors"
    #   }
    # '';
  };
}
