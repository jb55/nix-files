machine:
{ config, lib, pkgs, ... }:
{
  networking.hostName = machine;
  networking.extraHosts = ''
    172.24.160.85 phone
    172.24.14.20 archer
    172.24.206.82 charon
  '';

  networking.firewall.allowPing = true;
}
