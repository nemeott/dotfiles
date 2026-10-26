# Useful Zram resource: https://notes.xeome.dev/notes/Zram
# https://wiki.archlinux.org/title/Zram#Optimizing_swap_on_zram

_:

{
  boot = {
    kernel.sysctl = {
      # Zram settings
      "vm.page-cluster" = 0; # Use with zramSwap
      "vm.watermark_boost_factor" = 0;
      "vm.watermark_scale_factor" = 125;
      "vm.swappiness" = 180;
      # "vm.swappiness" = 10; # Use normal swap less often
    };
  };

  zramSwap = {
    enable = true;

    algorithm = "lz4"; # Compression algorithm; lz4 is lightweight and fast (default is zstd)
    memoryPercent = 40;
  };
}
