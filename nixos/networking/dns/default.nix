{ ... }:

{
  imports = [
    ./dns.nix
    #./systemd-resolved.nix # Returns NXDOMAIN in China Mainland, will investegate...
  ];
}