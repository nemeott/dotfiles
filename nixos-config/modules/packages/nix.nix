_:

{
  # Use Lix package manager instead of Nix
  # Override packages that use Nix to use Lix instead
  # Overlay help: https://github.com/NixOS/nixpkgs/pull/445223#issuecomment-3330902652
  nixpkgs.overlays = [
    (final: prev: {
      nix = final.lixPackageSets.latest.lix;

      inherit (final.lixPackageSets.latest)
        nixpkgs-review
        nurl
        nix-init
        nix-update
        nix-direnv
        nil
        # nixd
        # nix-eval-jobs
        nix-fast-build
        colmena
        ;

      lixPackageSets = prev.lixPackageSets.override {
        inherit (prev)
          nixpkgs-review
          nurl
          nix-init
          nix-update
          nix-direnv
          nil
          # nixd
          # nix-eval-jobs
          nix-fast-build
          colmena
          ;
      };
    })
  ];

  # Settings to make builds faster
  nix = {
    daemonIOSchedClass = "best-effort"; # (default)
    daemonCPUSchedPolicy = "batch"; # Optimized for non-interactive tasks
    daemonIOSchedPriority = 2; # Higher priority for IO operations

    # Enable flakes
    settings = {
      keep-derivations = true; # Default
      keep-outputs = true; # Keep build outputs for fast package rebuilds
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 7d"; # Keep previous week
      dates = "weekly"; # Monday at midnight
      persistent = true; # Do after reboot if system was shut down early
      randomizedDelaySec = "300"; # Random delay to avoid running at the same time as other services (5 min)
    };
    optimise = {
      automatic = true;
      dates = "weekly"; # Monday at midnight
      persistent = true; # Do after reboot if system was shut down early
      randomizedDelaySec = "300"; # Random delay to avoid running at the same time as other services (5 min)
    };
  };

  # Don't build NixOS manual to improve build times
  documentation.nixos.enable = false; # ~5 sec
}
