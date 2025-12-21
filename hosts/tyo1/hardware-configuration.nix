{
  boot.loader.grub.device = "/dev/vda";

  boot = {
    initrd.availableKernelModules = [
      "ata_piix"
      "uhci_hcd"
      "xen_blkfront"
      "vmw_pvscsi"
    ];
    initrd.kernelModules = [ "nvme" ];
  };

  fileSystems."/" = {
    device = "/dev/vda1";
    fsType = "ext4";
  };

  networking = {
    useNetworkd = true;
    useDHCP = false;
  };

  services.cloud-init = {
    enable = true;
    network = {
      enable = true;
    };
    settings = {
      cloud_init_modules = [ ];
      cloud_config_modules = [ ];
      cloud_final_modules = [ ];
    };
  };
}
