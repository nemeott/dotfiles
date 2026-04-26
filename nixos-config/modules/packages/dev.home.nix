{ pkgs, ... }:

let
  statix = pkgs.statix.overrideAttrs (_o: rec {
    src = pkgs.fetchFromGitHub {
      owner = "oppiliappan";
      repo = "statix";
      rev = "e9df54ce918457f151d2e71993edeca1a7af0132";
      hash = "sha256-duH6Il124g+CdYX+HCqOGnpJxyxOCgWYcrcK0CBnA2M=";
    };

    cargoDeps = pkgs.rustPlatform.importCargoLock {
      lockFile = src + "/Cargo.lock";
      allowBuiltinFetchGit = true;
    };
  });
in
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

      # TODO: Use zed-editor-fhs for better extension compatibility?
      package = pkgs.symlinkJoin {
        name = "zed-wrapped";
        paths = [ pkgs.zed-editor ];
        postBuild = ''
          rm $out/bin/zeditor
          cat > $out/bin/zeditor << 'EOF'
          #!/bin/sh
          systemctl --user start zed-coclean.timer
          exec ${pkgs.zed-editor}/bin/zeditor "$@"
          EOF
          chmod +x $out/bin/zeditor
        '';
      };

      extraPackages = with pkgs; [
        # Nix
        nil
        nixd
        statix # Nix lints and suggestions
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

  # Timer to run coclean
  systemd.user.timers.zed-coclean = {
    Unit.Description = "Run Zed copilot cleanup every 5 minutes";
    Timer = {
      OnActiveSec = "20s"; # Wait 20s before starting the clean on startup
      OnUnitActiveSec = "5m";
    };
  };

  # Clean up Zed's Copilot language server by killing all but the most recent process
  # Can't belive I need to make my own systemd service for this lmao
  systemd.user.services.zed-coclean = {
    Unit.Description = "Clean up Zed's Copilot language server for them";
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.writeShellScript "zed-coclean-script" ''
        set +e
        # If Zed isn't running, don't do anything and stop the timer
        if ! ${pkgs.procps}/bin/pgrep -f zed-editor > /dev/null; then
          systemctl --user stop zed-coclean.timer
          exit 0
        fi
        ${pkgs.procps}/bin/pgrep -f copilot-language-server \
        | ${pkgs.coreutils}/bin/sort -n \
        | ${pkgs.coreutils}/bin/head -n -1 \
        | ${pkgs.findutils}/bin/xargs -r ${pkgs.coreutils}/bin/kill
      ''}";
    };
  };
}
