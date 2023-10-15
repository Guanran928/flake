{ ... }:

{
  networking.networkmanager.dns = "systemd-resolved";
  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = [ "~." ];
    fallbackDns = [ "8.8.8.8#dns.google" "8.8.4.4#dns.google" "2001:4860:4860::8888#dns.google" "2001:4860:4860::8844#dns.google" ];
    extraConfig = "DNSOverTLS=yes";
  };
}