extra:
{ config, lib, pkgs, ... }:
let extras = (rec { ztip = "172.24.172.226";
                    nix-serve = {
                      port = 10845;
                      bindAddress = ztip;
                    };
                }) // extra;
    util = extra.util;
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
  users.extraGroups.vboxusers.members = [ "jb55" ];
  users.extraGroups.tor.members = [ "jb55" ];
  users.extraGroups.nginx.members = [ "jb55" ];

  programs.mosh.enable = true;
  services.trezord.enable = false;
  services.redis.enable = false;

  services.mongodb.enable = true;
  services.tor.enable = true;
  services.tor.extraConfig = extras.private.tor.extraConfig;
  services.fcgiwrap.enable = true;

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
  '';

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
