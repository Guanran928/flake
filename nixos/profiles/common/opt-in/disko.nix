{disks ? ["/dev/sda"], ...}: let
  mountOptions = ["defaults" "compress=zstd" "noatime"];
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
            "cryptedroot" = {
              end = "-16G";
              content = {
                type = "luks";
                name = "cryptedroot";
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
            "cryptedswap" = {
              end = "-16G";
              content = {
                type = "luks";
                name = "cryptedswap";
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
