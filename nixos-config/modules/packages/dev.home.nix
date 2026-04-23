{ pkgs, ... }:

{
  catppuccin.zed.enable = false; # Handle themes separately in Zed

  programs = {
    gh.enable = true;

    # Locate Nix packages and provide command-not-found integration
    nix-index = {
      enable = true;
      enableBashIntegration = true; # TODO: Why doesn't this work (command-not-found)
    };
    nix-index-database.comma.enable = true; # nix-shell and nix-index wrapper

    zed-editor = {
      enable = true;
      extraPackages = with pkgs; [
        # Nix
        nil
        nixd
        package-version-server # For showing package versions

        # Python
        ruff # Linter and formatter
        # ty # Type checker and language server
        pyrefly # Type checker and language server (more accurate than ty) (better features than zuban rn)
        zuban # Type checker and language server (more accurate than ty or pyrefly)

        # Rust
        rustc
        rust-analyzer
        cargo
        rustfmt
        clippy

        # Shell
        shellcheck
        shfmt
      ];
    };
  };
}
