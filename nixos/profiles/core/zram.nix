{lib, ...}: {
  services.zram-generator = {
    enable = true;
    settings.zram0 = {
      compression-algorithm = lib.mkDefault "zstd";
      zram-size = lib.mkDefault "ram";
    };
  };

  # https://wiki.archlinux.org/title/Zram#Optimizing_swap_on_zram
  boot.kernel.sysctl = {
    "vm.swappiness" = 180;
    "vm.watermark_boost_factor" = 0;
    "vm.watermark_scale_factor" = 125;
    "vm.page-cluster" = 0;
  };
}
