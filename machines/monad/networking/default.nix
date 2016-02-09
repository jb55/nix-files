{ config, lib, pkgs, ... }:
{
  networking.firewall.allowedTCPPorts = [ 8999 22 143 80 5000 ];
  networking.firewall.allowedUDPPorts = [ 11155 ];
}
