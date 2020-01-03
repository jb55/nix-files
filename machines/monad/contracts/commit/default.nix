{ config, lib, pkgs, ... }:
{
  # services.kubernetes = {
  #   apiserver.enable = true;
  #   controllerManager.enable = true;
  #   scheduler.enable = true;
  #   addonManager.enable = true;
  #   proxy.enable = true;
  #   flannel.enable = true;
  #   masterAddress = "127.0.0.1";
  # };

  #services.kubernetes.masterAddress = "127.0.0.1";
  #services.kubernetes.roles = [ "master" "node" ];

  # services.openvpn.servers.commit = {
  #   autoStart = true;
  #   config = builtins.readFile ./commit.ovpn;
  # };
}
