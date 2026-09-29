{ pkgs, ... }:

{
  environment.systemPackages = [
    # Custom script to display Zswap stats
    (pkgs.writeShellScriptBin "zswap" (builtins.readFile ../../scripts/zswap.sh))
  ];

  boot = {
    kernel.sysctl = {
      # Zswap settings
      "vm.swappiness" = 30;
    };

    zswap = {
      enable = true;

      # Useful compression algorithm resource: https://morotti.github.io/lzbench-web/
      # lz4 much faster (especially decode) than lzo with slightly worse compression
      compressor = "lz4"; # Compression algorithm; lz4 is lightweight and fast (default is zstd; kernel default is lzo)
      zpool = "zsmalloc"; # Default
      maxPoolPercent = 40; # Maximum percentage of RAM zswap is allowed to use (25% default)
      acceptThresholdPercent = 80; # Percentage at which zswap starts accepting pages after pool full (default 90%)
      shrinkerEnabled = true; # Enable zswap shrinker to reclaim memory when under pressure (default true)
    };
  };
}
