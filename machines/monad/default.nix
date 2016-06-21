{ config, lib, pkgs, ... }:
{
  imports = [
    ./hardware
  ];

  networking.nameservers = [ "8.8.8.8" "8.8.4.4" ];
  networking.firewall.allowedTCPPorts = [ 8999 22 143 80 5000 ];
  networking.firewall.allowedUDPPorts = [ 11155 ];

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "jb55" ];
}
