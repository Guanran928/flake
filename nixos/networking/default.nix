{ ... }:

{
  imports = [
    ./dns
    ./network-manager

    ./dhcp.nix
    ./firewall.nix
    ./proxy.nix
  ];
}
