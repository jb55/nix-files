machine:
{ config, lib, pkgs, ... }:
{
  networking.hostName = machine;

  networking.firewall.allowPing = true;
}
