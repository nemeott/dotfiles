{ pkgs, ... }:

{
  catppuccin.zed.enable = false; # Handle themes separately in Zed

  programs = {
    gh.enable = true;

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
        pyrefly # Type checker and language server (more accurate than ty)
        zuban # Type checker and language server (more mature than ty or pyrefly)

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
