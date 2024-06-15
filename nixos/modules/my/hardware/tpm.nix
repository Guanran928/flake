{
  lib,
  config,
  ...
}: let
  cfg = config.my.hardware.tpm;
in {
  options = {
    my.hardware.tpm.enable = lib.mkEnableOption "TPM";
  };

  # https://nixos.wiki/wiki/TPM
  config = lib.mkIf cfg.enable {
    security.tpm2 = {
      enable = true;
      pkcs11.enable = true;
      tctiEnvironment.enable = true;
    };
  };
}
