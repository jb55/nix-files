extra:
{ config, lib, pkgs, ... }:
let util = extra.util;
    nix-serve = extra.machine.nix-serve;
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
    (import ./networking extra)
    (import ./nginx extra)
  ];

  virtualisation.virtualbox.host.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  users.extraGroups.vboxusers.members = [ "jb55" ];
  users.extraGroups.tor.members = [ "jb55" ];
  users.extraGroups.nginx.members = [ "jb55" ];

  programs.mosh.enable = true;
  # services.trezord.enable = false;
  services.redis.enable = false;

  services.mongodb.enable = true;
  services.tor.enable = true;
  services.tor.extraConfig = extra.private.tor.extraConfig;
  services.fcgiwrap.enable = true;

  services.nix-serve.enable = true;
  services.nix-serve.bindAddress = nix-serve.bindAddress;
  services.nix-serve.port = nix-serve.port;

  services.nginx.httpConfig = if (config.services.nginx.enable && config.services.nix-serve.enable) then ''
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
  '' else "";

  services.footswitch = {
    enable = true;
    enable-led = true;
    led = "input5::numlock";
  };

  services.postgresql = {
    dataDir = "/var/db/postgresql/100/";
    enable = true;
    package = pkgs.postgresql100;
    # extraPlugins = with pkgs; [ pgmp ];
    authentication = pkgs.lib.mkForce ''
      # type db  user address            method
      local  all all                     trust
      host   all all  127.0.0.1/32       trust
    '';
    # extraConfig = ''
    #   listen_addresses = '172.24.172.226,127.0.0.1'
    # '';
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
