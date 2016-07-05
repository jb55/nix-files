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

  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0666"
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="05c4", MODE="0666"
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", KERNELS=="0005:054C:05C4.*", MODE="0666"
  '';

  systemd.services.ds4ctl = {
    description = "Dim ds4 leds based on power";

    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-udev-settle.service" ];

    startAt = "*:0/1";

    serviceConfig.Type = "oneshot";
    serviceConfig.ExecStart = ''
      ${pkgs.ds4ctl}/bin/ds4ctl
    '';
  };

  systemd.services.ds4ctl.enable = true;

}
