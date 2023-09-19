{ ... }:

{
  # TPM is currently broken on latest kernel,
  # but luckily, linux-zen have a patch for it
  # UPDATE: it got fixed in 6.5.3
  security.tpm2 = {
    enable = true;
    pkcs11.enable = true; # expose /run/current-system/sw/lib/libtpm2_pkcs11.so
    tctiEnvironment.enable = true; # tpm2tools_tcti and tpm2_pkcs11_tcti env variables
  };
}
