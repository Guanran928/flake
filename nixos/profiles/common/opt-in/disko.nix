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
                mountOptions = ["defaults" "umask=007"];
              };
            };
            "luks" = {
              end = "-16G";
              content = {
                type = "luks";
                name = "crypted";
                settings = {
                  allowDiscards = true;
                  bypassWorkqueues = true;
                };
                content = {
                  type = "btrfs";
                  subvolumes = let
                    mountOptions = ["defaults" "compress=zstd" "noatime"];
                  in {
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
