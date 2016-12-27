extra:
{ config, lib, pkgs, ... }:
let adblock-hosts = pkgs.fetchurl {
      url    = "https://jb55.com/s/ad-sources.txt";
      sha256 = "d9e6ae17ecc41eb7021c0552548a1c8da97efbb61e3a750fb023674d01d81134";
    };
    dnsmasq-adblock = pkgs.fetchurl {
      url = "https://jb55.com/s/dnsmasq-ad-sources.txt";
      sha256 = "3b34e565fb240c4ac1d261cb223bdc2d992fa755b5f6e981144e5b18f96f260d";
    };
    npmrepo = (import (pkgs.fetchFromGitHub {
      owner  = "jb55";
      repo   = "npm-repo-proxy";
      rev    = "81182f25cb783a986d7b7ee4a63f0ca6ca9c8989";
      sha256 = "0zj7ys0383fs3hykax5bd6q5wrhzcipy8j3div83mba2n7c13f8l";
    }) {}).package;
    hearpress = (import <jb55pkgs> { nixpkgs = pkgs; }).hearpress;
in
{
  imports = [
    ./networking
    ./hardware
    (import ./nginx extra)
    (import ./vidstats extra)
  ];

  security.acme.certs."jb55.com" = {
    webroot = "/var/www/challenges";
    email = "bill@casarin.me";
  };

  security.acme.certs."hearpress.com" = {
    webroot = "/var/www/challenges";
    email = "bill@casarin.me";
  };

  services.postgresql = {
    dataDir = "/var/db/postgresql/9.5/";
    enable = true;
    authentication = ''
      # type db  user address        method
      local  all all                 trust
      host   all all  127.0.0.1/32   trust
      host   all all  172.24.0.0/16  trust
    '';
    extraConfig = ''
      listen_addresses = '0.0.0.0'
    '';
  };

  systemd.services.npmrepo = {
    description = "npmrepo.com";

    wantedBy = [ "multi-user.target" ];

    serviceConfig.Type = "simple";
    serviceConfig.ExecStart = "${npmrepo}/bin/npm-repo-proxy";
  };

  # systemd.services.postgrest = {
  #   description = "PostgREST";

  #   wantedBy = [ "multi-user.target" ];
  #   after    = [ "postgresql.target" ];

  #   serviceConfig.Type = "simple";
  #   serviceConfig.ExecStart = ''
  #     ${pkgs.haskellPackages.postgrest}/bin/postgrest \
  #       'postgres://localhost/wineparty' \
  #       -a jb55
  #   '';
  # };

#   systemd.services.weechat = {
#     description = "Weechat relay server";
#     wantedBy = [ "multi-user.target" ];
#     serviceConfig.Type = "oneshot";
#     serviceConfig.RemainAfterExit = "yes";
#     serviceConfig.ExecStart = pkgs.writeScript "weechat-service" ''
# #!${pkgs.bash}/bin/bash
#       set -e
#       ${pkgs.rsync}/bin/rsync -rlD ${pkgs.jb55-dotfiles}/.weechat/ /tmp/weechat/
#       ${pkgs.tmux.bin}/bin/tmux -S /run/tmux-weechat new-session -d -s weechat -n 'weechat' '${pkgs.weechat}/bin/weechat-curses -d /tmp/weechat'
#     '';
#     serviceConfig.ExecStop = "${pkgs.tmux}/bin/tmux -S /run/tmux-weechat kill-session -t weechat";
#   };

  # systemd.services.weechat.enable = false;

  systemd.services.hearpress = {
    description = "Hearpress server";
    wantedBy = [ "multi-user.target" ];
    after = [ "postgresql.service" ];

    environment = {
      PG_CS = "postgresql://jb55@localhost/hearpress";
      AWS_ACCESS_KEY_ID = extra.private.aws.access_key;
      AWS_SECRET_ACCESS_KEY = extra.private.aws.secret_key;
    };

    serviceConfig.Type = "simple";
    serviceConfig.ExecStart = "${hearpress}/bin/hearpressd";
  };

  services.dnsmasq.enable = false;
  services.dnsmasq.servers = ["8.8.8.8" "8.8.4.4"];
  services.dnsmasq.extraConfig = ''
    addn-hosts=${adblock-hosts}
    conf-file=${dnsmasq-adblock}
  '';

  networking.firewall.allowedTCPPorts = [ 22 443 80 ];
  networking.firewall.allowedUDPPorts = [ ];
  networking.firewall.trustedInterfaces = ["zt0"];
}
