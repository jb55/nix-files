extra:
{ config, lib, pkgs, ... }:
let extras = (rec { ztip = "172.24.172.226";
                    nix-serve = {
                      port = 10845;
                      bindAddress = ztip;
                    };
                }) // extra;
in
{
  imports = [
    ./hardware
    (import ./networking extra)
    (import ./nginx extra)
  ];

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "jb55" ];
  users.extraGroups.tor.members = [ "jb55" ];
  users.extraGroups.nginx.members = [ "jb55" ];

  programs.mosh.enable = false;
  services.trezord.enable = false;
  services.redis.enable = false;

  services.mongodb.enable = true;
  services.tor.enable = true;
  services.tor.extraConfig = extras.private.tor.extraConfig;
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

    # arduino
    SUBSYSTEM=="usb", ATTRS{idVendor}=="2341", ATTRS{idProduct}=="0043", MODE="0666", SYMLINK+="arduino"
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

  services.nix-serve.enable = true;
  services.nix-serve.bindAddress = extras.nix-serve.bindAddress;
  services.nix-serve.port = extras.nix-serve.port;

  services.nginx.httpConfig = (if (config.services.nginx.enable && config.services.nix-serve.enable) then ''
    server {
      listen ${extras.nix-serve.bindAddress}:80;
      server_name cache.monad.jb55.com;

      location / {
        proxy_pass  http://${extras.nix-serve.bindAddress}:${toString extras.nix-serve.port};
        proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;
        proxy_redirect off;
        proxy_buffering off;
        proxy_set_header        Host            $host;
        proxy_set_header        X-Real-IP       $remote_addr;
        proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
      }
    }
  '' else "") + extra.private.tor.nginx;

  systemd.user.services.muchsync = {
    description = "muchsync - notmuch email sync with charon";
    path = with pkgs; [ notmuch openssh ];
    wantedBy = [ "default.target" ];
    serviceConfig.ExecStart = "${pkgs.muchsync}/bin/muchsync charon";
  };

  systemd.user.timers.muchsync = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*:0/10";
    };
  };

#  systemd.services.ds4ctl = {
#    enable = false;
#    description = "Dim ds4 leds based on power";
#
#    wantedBy = [ "multi-user.target" ];
#    after = [ "systemd-udev-settle.service" ];
#
#    startAt = "*:*:0/15";
#
#    serviceConfig.Type = "oneshot";
#    serviceConfig.ExecStart = ''
#      ${pkgs.ds4ctl}/bin/ds4ctl
#    '';
#  };

  services.footswitch = {
    enable = true;
    enable-led = true;
    led = "input5::numlock";
  };

  services.postgresql = {
    dataDir = "/var/db/postgresql/9.5/";
    enable = false;
    # extraPlugins = with pkgs; [ pgmp ];
    authentication = pkgs.lib.mkForce ''
      # type db  user address            method
      local  all all                     trust
      host   all all  172.24.172.226/16  trust
      host   all all  127.0.0.1/16       trust
    '';
    extraConfig = ''
      listen_addresses = '172.24.172.226,127.0.0.1'
    '';
  };

}
