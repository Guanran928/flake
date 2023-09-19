{ ... }:

{
  imports = [
    ./dns
    ./network-manager

    ./dhcp.nix
    ./dns
    ./firewall.nix
    ./proxy.nix
    ./timezone.nix
  ];
}
