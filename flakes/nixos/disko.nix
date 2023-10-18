{ inputs, disks ? [ "/dev/vdb" ], ... }:

{
  imports = [ inputs.disko.nixosModules.disko ];

  disko.devices = {
    disk = {
      "one" = {
        type = "disk";
        device = builtins.elemAt disks 0;
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "2G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "defaults" "fmask=0077" "dmask=0077"
                ];
              };
            };
            luks = {
              #size = "100%";
              end = "-16G";
              content = {
                type = "luks";
                name = "crypted";
                extraOpenArgs = [ "--allow-discards" ];
                # if you want to use the key for interactive login be sure there is no trailing newline
                # for example use `echo -n "password" > /tmp/secret.key`
                passwordFile = "/tmp/secret.key"; # Interactive
                #settings.keyFile = "/tmp/secret.key";
                #additionalKeyFiles = [ "/tmp/additionalSecret.key" ];
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  mountpoint = "/btrfs";
                  subvolumes = {
                    "/@home" = {
                      mountpoint = "/home";
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                    "/@nix" = {
                      mountpoint = "/nix";
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                  };
                };
              };
            };
            swap = {
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
