{ inputs, ... }:
let
  mountOptions = [
    "compress-force=zstd"
    "noatime"
  ];
in
{
  imports = [ inputs.disko.nixosModules.disko ];

  disko.devices = {
    disk.nvme0n1 = {
      type = "disk";
      device = "/dev/nvme0n1";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            type = "EF02";
            label = "BOOT";
            start = "0";
            end = "+1M";
          };
          root = {
            end = "-0";
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];
              subvolumes = {
                "/@boot" = {
                  mountpoint = "/boot";
                  inherit mountOptions;
                };
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
      };
    };
    nodev = {
      "/" = {
        fsType = "tmpfs";
        mountOptions = [
          "defaults"
          "mode=755"
        ];
      };
    };
  };

  fileSystems."/persist".neededForBoot = true;
}
