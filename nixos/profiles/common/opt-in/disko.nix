{disks ? ["/dev/sda"], ...}: {
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
                mountOptions = [
                  "defaults"
                  "fmask=0077"
                  "dmask=0077"
                ];
              };
            };
            "luks" = {
              end = "-16G";
              content = {
                type = "luks";
                name = "crypted";
                settings.allowDiscards = true;
                content = {
                  type = "btrfs";
                  subvolumes = {
                    "/@nix" = {
                      mountpoint = "/nix";
                      mountOptions = ["defaults" "compress=zstd" "noatime"];
                    };
                    "/@persist" = {
                      mountpoint = "/persist";
                      mountOptions = ["defaults" "compress=zstd" "noatime"];
                    };
                  };
                };
              };
            };
            "swap" = {
              size = "100%";
              content = {
                type = "swap";
                randomEncryption = true;
                #resumeDevice = true; # resume from hiberation from this device
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
