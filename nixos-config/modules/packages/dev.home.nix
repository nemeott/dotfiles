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
        # Nix lints
        (statix.overrideAttrs (_o: rec {
          src = fetchFromGitHub {
            owner = "oppiliappan";
            repo = "statix";
            rev = "e9df54ce918457f151d2e71993edeca1a7af0132";
            hash = "sha256-duH6Il124g+CdYX+HCqOGnpJxyxOCgWYcrcK0CBnA2M=";
          };

          cargoDeps = pkgs.rustPlatform.importCargoLock {
            lockFile = src + "/Cargo.lock";
            allowBuiltinFetchGit = true;
          };
        }))
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
