let
  # compress-force: https://t.me/archlinuxcn_group/3054167
  mountOptions = [
    "compress-force=zstd"
    "noatime"
  ];
  cryptSettings = {
    allowDiscards = true;
    bypassWorkqueues = true;
  };
in
{
  disko.devices = {
    disk = {
      "one" = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            "esp" = {
              size = "2G";
              type = "EF00";
              priority = -100;
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=007" ];
              };
            };
            "cryptroot" = {
              end = "-16G";
              content = {
                type = "luks";
                name = "cryptroot";
                passwordFile = "/tmp/secret.key";
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
                passwordFile = "/tmp/secret.key";
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
          "size=16G"
          "mode=755"
          "nodev"
          "nosuid"
        ];
      };
    };
  };
}
