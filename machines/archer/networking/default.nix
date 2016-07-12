{ config, lib, pkgs, ... }:
{
  networking.firewall.allowedTCPPorts = [ 8999 22 143 80 5000 5432 ];
}
