{ config, lib, pkgs, ... }:
{
  networking.firewall.allowedTCPPorts = [ 22 ];
}
