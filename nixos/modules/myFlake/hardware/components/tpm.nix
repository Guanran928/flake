{
  lib,
  config,
  ...
}: let
  cfg = config.myFlake.hardware.components.tpm;
in {
  options = {
    myFlake.hardware.components.tpm.enable = lib.mkEnableOption "Whether to enable TPM.";
  };

  # https://nixos.wiki/wiki/TPM
  config = lib.mkIf cfg.enable {
    # TPM is currently broken on latest kernel,
    # but luckily, linux-zen have a patch for it
    # UPDATE: it got fixed in 6.5.3
    #
    # python3.11-tpm2-pytss-2.1.0 failed with exit code 1 after ⏱ 34s
    security.tpm2 = {
      enable = true;
      #pkcs11.enable = true; # expose /run/current-system/sw/lib/libtpm2_pkcs11.so
      tctiEnvironment.enable = true; # tpm2tools_tcti and tpm2_pkcs11_tcti env variables
    };
  };
}
