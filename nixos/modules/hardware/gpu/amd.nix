{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.myFlake.nixos.hardware.gpu.amd;
in {
  options = {
    myFlake.nixos.hardware.gpu.amd.enable = lib.mkEnableOption "Whether to enable AMD GPU.";
  };

  # https://nixos.wiki/wiki/AMD_GPU
  config = lib.mkIf cfg.enable {
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

    boot.initrd.kernelModules = ["amdgpu"];
    services.xserver.videoDrivers = ["amdgpu"];

    # OpenCL
    hardware.opengl = {
      extraPackages = with pkgs; [
        amdvlk
        rocm-opencl-icd
        rocm-opencl-runtime
      ];
      # Only available on unstable
      extraPackages32 = with pkgs; [
        driversi686Linux.amdvlk
      ];
    };

    # HIP
    systemd.tmpfiles.rules = [
      "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.hip}"
    ];
  };
}
