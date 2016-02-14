{ config, lib, pkgs, ... }:
{
  networking.firewall.allowedTCPPorts = [ 22 443 80 ];
}
