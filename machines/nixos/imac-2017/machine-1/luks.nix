{ ... }:

# I have no idea what are those options
# and I dont use LUKS on my main machine...
# Assuming those are LUKS stuff :P
#
# it just works(tm)
{
  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };
  boot.initrd.luks.devices."luks-998ea901-91c0-4c20-82f4-5dbcce1e1877".device = "/dev/disk/by-uuid/998ea901-91c0-4c20-82f4-5dbcce1e1877";
}