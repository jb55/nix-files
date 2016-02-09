machine:
{ config, lib, pkgs, ... }:
{
  networking = {
    hostName = machine;
    extraHosts = ''
      174.143.211.135 freenode.znc.jb55.com
      172.24.160.85 phone
      172.24.14.20 archer
    '';

    firewall = {
      allowPing = true;
      allowedTCPPorts = [ 22 5000 143 ];
      allowedUDPPorts = [ 11155 ];
    };
  };
}
