{ config, lib, pkgs, ... }:
let
  user-file = pkgs.writeText "plastiq-user" ''
    will.casarin
  '';
in
{
  services.openvpn.servers.plastiq = {
    autoStart = false;
    config = import ./plastiq.ovpn.nix user-file;
  };
}
