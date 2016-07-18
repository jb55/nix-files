{ config, lib, pkgs, ... }:
{
  networking.firewall.allowedTCPPorts = [ 22 143 80 ];
  networking.firewall.trustedInterfaces = ["zt0"];
}
