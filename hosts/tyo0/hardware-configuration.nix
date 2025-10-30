{
  boot.loader.grub.device = "/dev/vda";
  boot.initrd.availableKernelModules = [
    "ata_piix"
    "uhci_hcd"
    "xen_blkfront"
    "vmw_pvscsi"
  ];
  boot.initrd.kernelModules = [ "nvme" ];
  fileSystems."/" = {
    device = "/dev/vda1";
    fsType = "ext4";
  };

  systemd.network.networks.ethernet = {
    matchConfig.Name = [
      "en*"
      "eth*"
    ];
    address = [
      "178.239.125.6/24"
      "2602:fd6f:1f:3ed::324/64"
    ];
    routes = [
      { Gateway = "178.239.125.1"; }
      { Gateway = "2602:fd6f:1f::1"; }
    ];
  };

  networking = {
    useNetworkd = true;
    useDHCP = false;
    nameservers = [
      "178.239.124.254"
      "8.8.8.8"
      "2606:4700:47008.8.8.8111"
    ];
  };

  services.udev.extraRules = ''
    ATTR{address}=="bc:24:11:9a:82:39", NAME="eth0"
  '';
}
