{inputs, ...}: {
  imports = [
    inputs.srvos.nixosModules.mixins-terminfo
  ];
}
