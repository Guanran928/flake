{pkgs, ...}:
# FOLLOWING https://nixos.wiki/wiki/AMD_GPU DIRECTLY
# I HAVE NO IDEA WHAT AM I DOING
{
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
}
