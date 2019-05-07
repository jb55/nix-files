extra:
{ config, lib, pkgs, ... }:
let util = extra.util;
    nix-serve = extra.machine.nix-serve;
    zenstates = pkgs.fetchFromGitHub {
      owner  = "r4m0n";
      repo   = "ZenStates-Linux";
      rev    = "0bc27f4740e382f2a2896dc1dabfec1d0ac96818";
      sha256 = "1h1h2n50d2cwcyw3zp4lamfvrdjy1gjghffvl3qrp6arfsfa615y";
    };
    email-notify = util.writeBash "email-notify-user" ''
      export HOME=/home/jb55
      export PATH=${lib.makeBinPath (with pkgs; [ eject libnotify muchsync notmuch openssh ])}:$PATH
      (
        flock -x -w 100 200 || exit 1

        muchsync charon

        #DISPLAY=:0 notify-send --category=email "you got mail"

      ) 200>/tmp/email-notify.lock
    '';
in
{
  imports = [
    ./hardware
    ./bitcoin.nix
    #(import ../../misc/dnsmasq-adblock.nix)
    (import ../../misc/msmtp extra)
    (import ./networking extra)
    (import ../../misc/imap-notifier extra)
  ];




  services.dnsmasq.enable = true;
  services.dnsmasq.resolveLocalQueries = true;
  services.dnsmasq.servers = ["1.1.1.1" "8.8.8.8"];
  services.dnsmasq.extraConfig = ''
    cache-size=10000
    addn-hosts=/var/hosts
    conf-file=/var/dnsmasq-hosts
    conf-file=/var/distracting-hosts
  '';


  systemd.services.block-distracting-hosts = {
    description = "Block Distracting Hosts";

    wantedBy = [ "default.target" ];
    after    = [ "default.target" ];

    path = with pkgs; [ systemd procps ];

    serviceConfig.ExecStart = util.writeBash "block-distracting-hosts" ''
      set -e
      cp /var/undistracting-hosts /var/distracting-hosts

      # crude way to clear the cache...
      systemctl restart dnsmasq
      pkill qutebrowser
    '';

    startAt = "Mon..Fri *-*-* 09:00:00";
  };

  systemd.user.services.stop-spotify-bedtime = {
    enable      = true;
    description = "Stop spotify when Elliott goes to bed";
    wantedBy    = [ "graphical-session.target" ];
    after       = [ "graphical-session.target" ];
    serviceConfig.ExecStart = "${pkgs.dbus}/bin/dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Stop";

    startAt = "*-*-* 19:30:00";
  };

  systemd.services.unblock-distracting-hosts = {
    description = "Unblock Distracting Hosts";

    wantedBy = [ "default.target" ];
    after    = [ "default.target" ];

    path = with pkgs; [ systemd ];

    serviceConfig.ExecStart = util.writeBash "unblock-distracting-hosts" ''
      set -e
      echo "" > /var/distracting-hosts
      systemctl restart dnsmasq
    '';

    startAt = "Mon..Fri *-*-* 17:00:00";
  };


  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableHardening = true;
  #virtualization.virtualbox.host.enableExtensionPack = true;
  users.extraUsers.jb55.extraGroups = [ "vboxusers" ];

  services.xserver.videoDrivers = [ "nvidiaBeta" ];

  users.extraGroups.tor.members = [ "jb55" "nginx" ];
  users.extraGroups.nginx.members = [ "jb55" ];
  users.extraGroups.transmission.members = [ "nginx" "jb55" ];

  programs.mosh.enable = false;

  documentation.nixos.enable = false;

  services.trezord.enable = true;
  services.redis.enable = false;
  services.zerotierone.enable = true;
  services.mongodb.enable = false;

  services.tor.enable = true;
  services.tor.controlPort = 9051;
  services.tor.client.enable = true;
  services.tor.extraConfig = extra.private.tor.extraConfig;

  services.fcgiwrap.enable = true;

  services.nix-serve.enable = false;
  services.nix-serve.bindAddress = nix-serve.bindAddress;
  services.nix-serve.port = nix-serve.port;

  services.nginx.enable = true;
  services.nginx.httpConfig = ''
      server {
        listen      80 default_server;
        server_name _;
        root /www/public;
        index index.html index.htm;
        location / {
          try_files $uri $uri/ =404;
        }
      }

      server {
        listen 80;
        server_name matrix.monad;

        root ${pkgs.riot-web};
        index index.html index.htm;
        location / {

          try_files $uri $uri/ =404;
        }
      }

    '' + (if config.services.nix-serve.enable then ''
      server {
        listen ${nix-serve.bindAddress}:80;
        server_name cache.monad.jb55.com;

        location / {
          proxy_pass  http://${nix-serve.bindAddress}:${toString nix-serve.port};
          proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;
          proxy_redirect off;
          proxy_buffering off;
          proxy_set_header        Host            $host;
          proxy_set_header        X-Real-IP       $remote_addr;
          proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
        }
      }
    '' else "") + (if config.services.tor.enable then extra.private.tor.nginx else "");

  services.footswitch = {
    enable = false;
    enable-led = true;
    led = "input5::numlock";
  };

  systemd.services.disable-c6 = {
    description = "Ryzen Disable C6 State";

    wantedBy = [ "basic.target" ];
    after = [ "sysinit.target" "local-fs.target" ];

    serviceConfig.Type = "oneshot";
    serviceConfig.ExecStart = util.writeBash "disable-c6-state" ''
      ${pkgs.kmod}/bin/modprobe msr
      ${pkgs.python2}/bin/python ${zenstates}/zenstates.py --c6-disable --list
    '';
  };

  services.postgresql = {
    dataDir = "/var/db/postgresql/100/";
    enable = true;
    package = pkgs.postgresql_10;
    # extraPlugins = with pkgs; [ pgmp ];
    authentication = pkgs.lib.mkForce ''
      # type db  user address            method
      local  all all                     trust
      host   all all  127.0.0.1/32       trust
      host   all all  192.168.86.0/24    trust
    '';
    extraConfig = ''
      listen_addresses = '0.0.0.0'
    '';
  };

  # security.pam.u2f = {
  #   enable = true;
  #   interactive = true;
  #   cue = true;
  #   control = "sufficient";
  #   authfile = "${pkgs.writeText "pam-u2f-config" ''
  #     jb55:vMXUgYb1ytYmOVgqFDwVOxJmvVI9F3gdSJVbvsi1A1VA-3mftTUhgARo4Kmm_8SAH6IJJ8p3LSXPSbtTSXMIpQ,04d8c1542a7391ee83112a577db968b84351f0090a9abe7c75bedcd94777cf15727c68ce4ac8858ff2812ded3c86d978efc5893b25cf906032632019fe792d3ec4
  #   ''}";
  # };

}
