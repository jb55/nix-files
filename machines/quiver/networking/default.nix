extra:
{ config, lib, pkgs, ... }:
let
  chromecastIPs = [ "192.168.86.190" ];
  iptables = "iptables -A nixos-fw";
  openChromecast = ip: ''
    ${iptables} -p udp -s ${ip} -j nixos-fw-accept
    ${iptables} -p tcp -s ${ip} -j nixos-fw-accept
  '';
  ipr = "${pkgs.iproute}/bin/ip";
  writeBash = extra.util.writeBash;
  openTCP = dev: port: ''
    ip46tables -A nixos-fw -i ${dev} -p tcp --dport ${toString port} -j nixos-fw-accept
  '';

in
{
  # workaround for starbucks blackholing 1.1.1.1 and 8.8.8.8 dns reqs
  networking.nameservers = [ "172.24.242.111" ];

  networking.extraHosts = ''
    10.0.9.1         secure.datavalet.io
    192.168.86.26    torrents.home.
    24.244.54.234    wifisignon.shaw.ca
  '';

  networking.wireless.userControlled.enable = true;

  networking.firewall.enable = true;
  networking.firewall.extraCommands = ''
    ${lib.concatStringsSep "\n\n" (map openChromecast chromecastIPs)}

    # home network nginx
    iptables -A nixos-fw -p tcp -s 192.168.86.0/24 -d 192.168.86.0/24 --dport 80 -j nixos-fw-accept

    ${openTCP "zt1" "9735"}
  '';

  networking.firewall.allowedTCPPorts = [ 8333 ];
}
