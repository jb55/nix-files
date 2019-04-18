{ config, lib, pkgs, ... }:
let
  adblock-hosts = pkgs.fetchurl {
                    url    = "https://jb55.com/s/ad-sources.txt";
                    sha256 = "d9e6ae17ecc41eb7021c0552548a1c8da97efbb61e3a750fb023674d01d81134";
                  };
  dnsmasq-adblock = pkgs.fetchurl {
                      url = "https://jb55.com/s/dnsmasq-ad-sources.txt";
                      sha256 = "3b34e565fb240c4ac1d261cb223bdc2d992fa755b5f6e981144e5b18f96f260d";
                    };
in
{
  services.dnsmasq.enable = true;
  services.dnsmasq.resolveLocalQueries = false;
  services.dnsmasq.servers = ["1.1.1.1" "8.8.8.8"];
  services.dnsmasq.extraConfig = ''
    addn-hosts=${adblock-hosts}
    conf-file=${dnsmasq-adblock}
  '';
}
