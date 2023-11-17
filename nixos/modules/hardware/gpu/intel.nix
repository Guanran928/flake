{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.myFlake.nixos.hardware.gpu.intel;
in {
  options = {
    myFlake.nixos.hardware.gpu.intel.enable = lib.mkEnableOption "Whether to enable Intel GPU.";
  };

  # https://nixos.wiki/wiki/Intel_Graphics
  config = lib.mkIf cfg.enable {
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

    boot.initrd.kernelModules = ["i915"]; # if not enabled, plymouth's distro logo wont show for some reason
    nixpkgs.config.packageOverrides = pkgs: {vaapiIntel = pkgs.vaapiIntel.override {enableHybridCodec = true;};};

    hardware.opengl = {
      extraPackages = with pkgs; [
        intel-media-driver # libva_driver_name=ihd
        vaapiIntel # libva_driver_name=i965 (older but works better for firefox/chromium)
        vaapiVdpau
        libvdpau-va-gl
        intel-compute-runtime # intel opencl
        intel-media-driver # intel vaapi
      ];
      extraPackages32 = with pkgs; [pkgsi686Linux.vaapiIntel];
    };
  };
}
