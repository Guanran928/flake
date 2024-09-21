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
    disk.vda = {
      type = "disk";
      device = "/dev/vda";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            type = "EF02";
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
