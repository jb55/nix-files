extra:
{ config, lib, pkgs, ... }:
{
  imports = [
    ./hardware
    (import ./nginx extra)
  ];

  networking.nameservers = [ "8.8.8.8" "8.8.4.4" ];
  # networking.firewall.allowedTCPPorts = [ 8999 22 143 80 5000 ];
  # networking.firewall.allowedUDPPorts = [ ];
  networking.firewall.trustedInterfaces = ["zt1"];

  virtualisation.virtualbox.host.enable = false;
  users.extraGroups.vboxusers.members = [ "jb55" ];

  programs.mosh.enable = true;
  services.mongodb.enable = true;
  services.mysql.enable = false;
  services.mysql.package = pkgs.mariadb;
  services.redis.enable = true;
  services.tor.enable = true;
  services.fcgiwrap.enable = true;

  services.udev.extraRules = ''
    # ds4
    KERNEL=="uinput", MODE="0666"
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="05c4", MODE="0666"
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", KERNELS=="0005:054C:05C4.*", MODE="0666"

    # vive hmd
    KERNEL=="hidraw*", ATTRS{idVendor}=="0bb4", ATTRS{idProduct}=="2c87", MODE="0666"

    # vive lighthouse
    KERNEL=="hidraw*", ATTRS{idVendor}=="28de", ATTRS{idProduct}=="2000", MODE="0666"

    # vive controller
    KERNEL=="hidraw*", ATTRS{idVendor}=="28de", ATTRS{idProduct}=="2101", MODE="0666"

    # vive audio
    KERNEL=="hidraw*", ATTRS{idVendor}=="0d8c", ATTRS{idProduct}=="0012", MODE="0666"

    # rtl-sdr
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0bda", ATTRS{idProduct}=="2832", MODE="0666", SYMLINK+="rtl_sdr"

  '';

  boot.blacklistedKernelModules = ["dvb_usb_rtl28xxu"];

  services.xserver.config = ''
    Section "InputClass"
      Identifier "Razer Razer DeathAdder 2013"
      MatchIsPointer "yes"
      Option "AccelerationProfile" "-1"
      Option "ConstantDeceleration" "5"
      Option "AccelerationScheme" "none"
      Option "AccelSpeed" "-1"
    EndSection

    Section "InputClass"
      Identifier "Logitech M705"
      MatchIsPointer "yes"
      Option "AccelerationProfile" "-1"
      Option "ConstantDeceleration" "5"
      Option "AccelerationScheme" "none"
      Option "AccelSpeed" "-1"
    EndSection
  '';

  systemd.services.ds4ctl = {
    description = "Dim ds4 leds based on power";

    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-udev-settle.service" ];

    startAt = "*:*:0/15";

    serviceConfig.Type = "oneshot";
    serviceConfig.ExecStart = ''
      ${pkgs.ds4ctl}/bin/ds4ctl
    '';
  };

  services.footswitch = {
    enable = true;
    enable-led = true;
    led = "input5::numlock";
  };
  systemd.services.ds4ctl.enable = true;

  services.postgresql = {
    dataDir = "/var/db/postgresql/9.5/";
    enable = true;
    # extraPlugins = with pkgs; [ pgmp ];
    authentication = pkgs.lib.mkForce ''
      # type db  user address            method
      local  all all                     trust
      host   all all  172.24.172.226/16  trust
      host   all all  192.168.86.100/16  trust
      host   all all  127.0.0.1/16       trust
    '';
    extraConfig = ''
      listen_addresses = '172.24.172.226,192.168.86.100,127.0.0.1'
    '';
  };

}
