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

        # Python
        ruff
        ty

        # Rust
        rustc
        rust-analyzer
        cargo
        rustfmt
        clippy
      ];
    };
  };
}
