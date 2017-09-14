{ config, lib, pkgs, ... }:
let
  openTCP = dev: port: ''
    ip46tables -A nixos-fw -i ${dev} -p tcp --dport ${toString port} -j nixos-fw-accept
  '';
in
{
  networking.firewall.allowedTCPPorts = [ 22 443 80 12566 12788 5222 5269  ];
  networking.firewall.trustedInterfaces = ["zt0"];

  networking.firewall.extraCommands = ''
    ${openTCP "zt0" 993}
    ${openTCP "zt0" 143}
    ${openTCP "zt0" 587}
  '';
}
