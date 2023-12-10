{disks ? ["/dev/sda"], ...}: {
  disko.devices = {
    disk = {
      "one" = {
        type = "disk";
        device = builtins.elemAt disks 0;
        content = {
          type = "gpt";
          partitions = {
            "ESP" = {
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
                extraOpenArgs = ["--allow-discards"];
                passwordFile = "/tmp/secret.key"; # Interactive
                content = {
                  type = "btrfs";
                  extraArgs = ["-f"];
                  mountpoint = "/btrfs";
                  subvolumes = {
                    "/@nix" = {
                      mountpoint = "/nix";
                      mountOptions = ["compress=zstd" "noatime"];
                    };
                    "/@persist" = {
                      mountpoint = "/persist";
                      mountOptions = ["compress=zstd" "noatime"];
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
                resumeDevice = true; # resume from hiberation from this device
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
          "size=2G"
          "defaults"
          "mode=755"
        ];
      };
    };
  };
}
