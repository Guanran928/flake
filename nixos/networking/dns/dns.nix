{ ... }:

{
  networking = {
    nameservers = [
      "223.5.5.5"
      "223.6.6.6" 
      "2400:3200::1" 
      "2400:3200:baba::1" 
      #"223.5.5.5#dns.alidns.com"
      #"223.6.6.6#dns.alidns.com"
      #"2400:3200::1#dns.alidns.com"
      #"2400:3200:baba::1#dns.alidns.com"
    ];
  };
}