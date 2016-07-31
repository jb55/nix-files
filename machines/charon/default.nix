{ config, lib, pkgs, ... }:
let adblock-hosts = pkgs.fetchurl {
      url    = "https://jb55.com/s/ad-sources.txt";
      sha256 = "d9e6ae17ecc41eb7021c0552548a1c8da97efbb61e3a750fb023674d01d81134";
    };
    dnsmasq-adblock = pkgs.fetchurl {
      url = "https://jb55.com/s/dnsmasq-ad-sources.txt";
      sha256 = "3b34e565fb240c4ac1d261cb223bdc2d992fa755b5f6e981144e5b18f96f260d";
    };
in
{
  imports = [
    ./networking
    ./hardware
    ./nginx
  ];

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

  systemd.services.postgrest = {
    description = "PostgREST";

    wantedBy = [ "multi-user.target" ];
    after    = [ "postgresql.target" ];

    serviceConfig.Type = "simple";
    serviceConfig.ExecStart = ''
      ${pkgs.haskellPackages.postgrest}/bin/postgrest \
        'postgres://localhost/wineparty' \
        -a jb55
    '';
  };

  systemd.services.weechat = {
    description = "Weechat relay server";

    wantedBy = [ "multi-user.target" ];

    serviceConfig.Type = "oneshot";
    serviceConfig.RemainAfterExit = "yes";
    serviceConfig.ExecStart = pkgs.writeScript "weechat-service" ''
#!${pkgs.bash}/bin/bash
      set -e
      ${pkgs.rsync}/bin/rsync -rlD ${pkgs.jb55-dotfiles}/.weechat/ /tmp/weechat/
      ${pkgs.tmux.bin}/bin/tmux -S /run/tmux-weechat new-session -d -s weechat -n 'weechat' '${pkgs.weechat}/bin/weechat-curses -d /tmp/weechat'
    '';
    serviceConfig.ExecStop = "${pkgs.tmux.bin}/bin/tmux -S /run/tmux-weechat kill-session -t weechat";

  };

  systemd.services.dnsmonitor = {
    description = "DNS monitor";
    
    wantedBy = [ "multi-user.target" ];
    after    = [ "postgresql.target" "dnsmasq.target" ];

    serviceConfig.Type = "simple";
    serviceConfig.ExecStart = pkgs.writeScript "dnsmonitor" ''
#!${pkgs.bash}/bin/bash
      ${pkgs.coreutils}/bin/stdbuf -o 0 \
        ${pkgs.wireshark}/bin/tshark \
          -l -i enp0s4 -n -T fields \
          -e "ip.src" \
          -e "dns.qry.name" \
          -e "dns.a" -Y "dns.flags.response eq 1" \
			| ${pkgs.coreutils}/bin/stdbuf -o 0 ${pkgs.gnused}/bin/sed 's#\([0-9\.]\{8,\}\)#"\1"#g' \
			| ${pkgs.coreutils}/bin/stdbuf -o 0 ${pkgs.gawk}/bin/gawk -F '\t' '{printf "insert into req (src_ip, name, ip) values ('"'"'{%s}'"'"', '"'"'%s'"'"', '"'"'{%s}'"'"');\n", $1, $2, $3}' \
			| ${pkgs.postgresql}/bin/psql -d dns >/dev/null
    '';
  };

  systemd.services.weechat.enable = true;
  systemd.services.postgrest.enable = true;
  systemd.services.dnsmonitor.enable = true;

  services.dnsmasq.enable = false;
  services.dnsmasq.servers = ["8.8.8.8" "8.8.4.4"];
  services.dnsmasq.extraConfig = ''
    addn-hosts=${adblock-hosts}
    conf-file=${dnsmasq-adblock}
  '';

  networking.firewall.allowedTCPPorts = [ 22 443 80 5432 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];
  networking.firewall.trustedInterfaces = ["zt0"];
} // let enabler = x: { systemd.services."pogom${x.subdomain}" };
     in lib.lists.fold {a: b: a // b} {} (map enabler extra.private.pokemaps);
