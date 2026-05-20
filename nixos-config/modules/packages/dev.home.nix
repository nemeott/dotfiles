_:

{
  programs = {
    gh.enable = true;

    uv = {
      enable = true;
      settings = {
        exclude-newer = "10 days"; # Prevent supply-chain attacks
      };
    };

    # Locate Nix packages and provide command-not-found integration
    nix-index = {
      enable = true;
      enableBashIntegration = true; # TODO: Why doesn't this work (command-not-found) (because not using HM managed bashrc?)
    };
    nix-index-database.comma.enable = true; # nix-shell and nix-index wrapper
  };
}
