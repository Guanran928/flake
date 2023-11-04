{...}: {
  # please configure `networking.knownNetworkServices` in ../hosts/your-machine.nix
  networking.dns = [
    "223.5.5.5"
    "223.6.6.6"
    "2400:3200::1"
    "2400:3200:baba::1"
    #"223.5.5.5#dns.alidns.com"
    #"223.6.6.6#dns.alidns.com"
    #"2400:3200::1#dns.alidns.com"
    #"2400:3200:baba::1#dns.alidns.com"
    #"8.8.8.8"
    #"8.8.4.4"
    #"2001:4860:4860::8888"
    #"2001:4860:4860::8844"
  ];
}
