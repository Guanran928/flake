{ ... }:

{
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/6288ce7a-a153-4302-a4de-5dc71f58da79";
      fsType = "btrfs";
      options = [ "compress=zstd" "subvol=@" ]; # nested subvol
    };
    #"/" = {
    #  device = "none";
    #  fsType = "tmpfs";
    #  options = [ "size=3G" "mode=755" ]; # mode=755 so only root can write to those files
    #};

    "/home" = {
      device = "/dev/disk/by-uuid/6288ce7a-a153-4302-a4de-5dc71f58da79";
      fsType = "btrfs";
      options = [ "compress=zstd" "subvol=@home" ];
    };

    "/var/lib/flatpak" = {
      device = "/dev/disk/by-uuid/6288ce7a-a153-4302-a4de-5dc71f58da79";
      fsType = "btrfs";
      options = [ "compress=zstd" "subvol=@flatpak" ];
    };

    "/btrfs" = {
      device = "/dev/disk/by-uuid/6288ce7a-a153-4302-a4de-5dc71f58da79";
      fsType = "btrfs";
      options = [ "compress=zstd" ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/C44A-313A";
      fsType = "vfat";
    };
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/0ba792d3-571d-44bb-8696-82126611784d"; } ];
}