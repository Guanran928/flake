let
  disks = ["/dev/nvme0n1"];
  # compress-force: https://t.me/archlinuxcn_group/3054167
  mountOptions = ["defaults" "compress-force=zstd" "noatime"];
  cryptSettings = {
    allowDiscards = true;
    bypassWorkqueues = true;
  };
in {
  disko.devices = {
    disk = {
      "one" = {
        type = "disk";
        device = builtins.elemAt disks 0;
        content = {
          type = "gpt";
          partitions = {
            "esp" = {
              size = "2G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["defaults" "umask=007"];
              };
            };
            "cryptroot" = {
              end = "-16G";
              content = {
                type = "luks";
                name = "cryptroot";
                settings = cryptSettings;
                content = {
                  type = "btrfs";
                  subvolumes = {
                    "/@nix" = {
                      mountpoint = "/nix";
                      inherit mountOptions;
                    };
                    "/@persist" = {
                      mountpoint = "/persist";
                      inherit mountOptions;
                    };
                  };
                };
              };
            };
            "cryptswap" = {
              size = "100%";
              content = {
                type = "luks";
                name = "cryptswap";
                settings = cryptSettings;
                content = {
                  type = "swap";
                  resumeDevice = true;
                };
              };
            };
          };
        };
      };
    };
    nodev = {
      "/" = {
        fsType = "tmpfs";
        mountOptions = [
          "defaults"
          "size=2G"
          "mode=755"
          "nodev"
          "nosuid"
        ];
      };
    };
  };
}
