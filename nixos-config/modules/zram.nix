# Useful Zram resource: https://notes.xeome.dev/notes/Zram

_:

{
  boot = {
    kernel.sysctl = {
      # Zram settings
      "vm.page-cluster" = 0; # Use with zramSwap
      "vm.swappiness" = 10; # Use normal swap less often
    };
  };

  zramSwap = {
    enable = true;

    algorithm = "lz4"; # Compression algorithm; lz4 is lightweight and fast (default is zstd)
    memoryPercent = 50;
  };
}
