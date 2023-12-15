{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.myFlake.hardware.components.gpu.intel;
in {
  options = {
    myFlake.hardware.components.gpu.intel.enable = lib.mkEnableOption "Whether to enable Intel GPU.";
  };

  # https://nixos.wiki/wiki/Intel_Graphics
  config = lib.mkIf cfg.enable {
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

    nixpkgs.config.packageOverrides = pkgs: {vaapiIntel = pkgs.intel-vaapi-driver.override {enableHybridCodec = true;};};
    hardware.opengl = {
      extraPackages = with pkgs; [
        intel-media-driver # libva_driver_name=ihd
        intel-vaapi-driver # libva_driver_name=i965 (older but works better for firefox/chromium)
        vaapiVdpau
        libvdpau-va-gl
        intel-compute-runtime # intel opencl
        intel-media-driver # intel vaapi
      ];
      extraPackages32 = with pkgs; [pkgsi686Linux.vaapiIntel];
    };
  };
}
