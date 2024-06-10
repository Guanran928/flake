{
  lib,
  config,
  ...
}: {
  options = {
    system.nixos.codeName = lib.mkOption {readOnly = false;};
  };

  config = {
    # https://github.com/NixOS/nixpkgs/issues/315574
    system.nixos.codeName = "骆马";

    services.getty.greetingLine = let
      inherit (config.system) nixos;
    in ''
      NixOS ${nixos.label} ${nixos.codeName} (\m) - \l
      ${lib.strings.optionalString (builtins.elem "nvidia" config.services.xserver.videoDrivers)
        "--my-next-gpu-wont-be-nvidia"}
      ${lib.strings.optionalString (builtins.elem "amdgpu" config.boot.initrd.kernelModules)
        "[    5.996722] amdgpu 0000:67:00.0: Fatal error during GPU init"}
    '';
  };
}
