_:

{
  programs = {
    gh.enable = true;

    # Locate Nix packages and provide command-not-found integration
    nix-index = {
      enable = true;
      enableBashIntegration = true; # TODO: Why doesn't this work (command-not-found)
    };
    nix-index-database.comma.enable = true; # nix-shell and nix-index wrapper
  };
}
