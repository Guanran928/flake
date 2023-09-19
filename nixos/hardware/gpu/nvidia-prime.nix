{ ... }:

# Nvidia Prime ( multi gpu on laptop )
{
  hardware.nvidia.prime = {
    sync.enable = false;
    nvidiaBusId = "PCI:1:0:0";
    intelBusId = "PCI:0:2:0";
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
  };
  environment.sessionVariables = {
    "GAMEMODERUNEXEC" = "env __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia __VK_LAYER_NV_optimus=NVIDIA_only"; # gamemode: nvidia offload
  };
}