machine:
{ config, lib, pkgs, ... }:
{
  networking.hostName = machine;
  networking.extraHosts = ''
    174.143.211.135 freenode.znc.jb55.com
    172.24.160.85 phone
    172.24.14.20 archer
    172.24.206.82 charon jb55.com
  '';

  networking.firewall.allowPing = true;
}
