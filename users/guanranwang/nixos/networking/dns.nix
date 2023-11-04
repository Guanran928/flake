{ lib, ... }:

{
  networking.nameservers = lib.mkForce [
    ### AliDNS
    "223.5.5.5"
    "223.6.6.6"
    "2400:3200::1"
    "2400:3200:baba::1"
  ];
}