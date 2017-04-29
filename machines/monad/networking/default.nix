extra:
{ config, lib, pkgs, ... }:
let
  chromecastIP = "192.168.86.190";
  iptables = "iptables -A nixos-fw";
  vpn = {
    name = "pia";
    table = "300";
    crt = pkgs.fetchurl {
      url = "https://jb55.com/s/0d1e6ada6bf5ed89.crt";
      sha256 = "920ce965329a8eee3b520aefed44db21c02b730e7d1b7bd540aa1c98d4caae44";
    };
    crl = pkgs.fetchurl {
      url = "https://jb55.com/s/1bef6d32bab94308.pem";
      sha256 = "64fbbf883bd29f8837cd0de22b1a0add32fb1d0eb6d31c8dc20532f9062f92b9";
    };
    credfile = pkgs.writeText "vpncreds" ''
      ${extra.private.vpncred.user}
      ${extra.private.vpncred.pass}
    '';
    routeup = writeBash "openvpn-pia-routeup" ''
      ${pkgs.iproute}/bin/ip route add default via $route_vpn_gateway dev $dev metric 1 table ${vpn.table}
      exit 0
    '';
#    up = writeBash "openvpn-pia-preup" config.services.openvpn.servers.pia.up;
#    down = writeBash "openvpn-pia-stop" config.services.openvpn.servers.pia.down;
  };
  openTCP = dev: port: ''
    ip46tables -A nixos-fw -i ${dev} -p tcp --dport ${toString port} -j nixos-fw-accept
  '';

  piaConfig = pkgs.writeText "pia-openvpn.conf" config.services.openvpn.servers.pia.config;

  writeBash = fname: body: pkgs.writeScript fname ''
    #! ${pkgs.bash}/bin/bash
    ${body}
  '';
in
{
  networking.nameservers = [ "8.8.8.8" "8.8.4.4" ];

  networking.firewall.extraCommands = ''
    ${openTCP "zt2" 80}
    ${openTCP "zt1" 80}
    ${iptables} -s 192.168.86.0/24 -p tcp --dport 80 -j nixos-fw-accept
    ${iptables} -p udp -s ${chromecastIP} -j nixos-fw-accept
    ${iptables} -p tcp -s ${chromecastIP} -j nixos-fw-accept
  '';

  users.extraGroups.vpn-pia.members = [ "jb55" "transmission" ];
  systemd.services.openvpn-pia.path = [ pkgs.libcgroup ];
  services.openvpn.servers = {
    pia = {
      autoStart = true;

      config = ''
        auth sha1
        auth-user-pass ${vpn.credfile}
        ca ${vpn.crt}
        cipher aes-128-cbc
        client
        comp-lzo
        crl-verify ${vpn.crl}
        dev tun
        disable-occ
        errors-to-stderr
        nobind
        persist-key
        persist-tun
        proto udp
        remote 104.200.154.67 1198
        remote-cert-tls server
        reneg-sec 0
        resolv-retry infinite
        tls-client
        route-noexec
        verb 1
        route-up ${vpn.routeup}
      '';

      up = ''
        # enable ip forwarding
        echo 1 > /proc/sys/net/ipv4/ip_forward

        # create cgroup for 3rd party VPN (can change 'vpn' to your name of choice)
        mkdir -p /sys/fs/cgroup/net_cls/${vpn.name}

        # give it an arbitrary id
        echo 11 > /sys/fs/cgroup/net_cls/${vpn.name}/net_cls.classid

        # grant a non-root user access
        cgcreate -t jb55:vpn-pia -a jb55:vpn-pia -g net_cls:${vpn.name}

        # mangle packets in cgroup with a mark
        iptables -t mangle -A OUTPUT -m cgroup --cgroup 11 -j MARK --set-mark 11

        # NAT packets in cgroup through VPN tun interface
        iptables -t nat -A POSTROUTING -m cgroup --cgroup 11 -o tun0 -j MASQUERADE

        # create separate routing table
        ip rule add fwmark 11 table ${vpn.table}

        # add fallback route that blocks traffic, should the VPN go down
        ip route add blackhole default metric 2 table ${vpn.table}

        # disable reverse path filtering for all interfaces
        for i in /proc/sys/net/ipv4/conf\/*/rp_filter; do echo 0 > $i; done
      '';

      down = ''
        echo 0 > /proc/sys/net/ipv4/ip_forward

        cgdelete -g net_cls:${vpn.name}

        # not sure if cgdelete does this...
        rm -rf /sys/fs/cgroup/net_cls/${vpn.name}
      '';
    };
  };

  networking.firewall.checkReversePath = false;
  networking.firewall.logReversePathDrops = true;

  services.transmission = {
    enable = true;
    settings = {
      download-dir = "/sand/torrents/downloads";
      incomplete-dir = "/sand/torrents/.incomplete";
      incomplete-dir-enable = true;
      rpc-whitelist = "127.0.0.1";
    };

    port = 14325;
  };

  systemd.services.transmission.wants = [ "openvpn-pia.service" ];
  systemd.services.transmission.after = [ "openvpn-pia.service" ];
  systemd.services.transmission.serviceConfig.User = lib.mkForce "root";
  systemd.services.transmission.serviceConfig.ExecStart = lib.mkForce (
    writeBash "start-transmission-under-vpn" ''
      ${pkgs.libcgroup}/bin/cgexec -g net_cls:pia \
        ${pkgs.sudo}/bin/sudo -u transmission \
          ${pkgs.transmission}/bin/transmission-daemon \
            -f \
            --port ${toString config.services.transmission.port};
    ''
  );

  services.plex = {
    enable = true;
    group = "transmission";
    openFirewall = true;
  };

  services.nginx.httpConfig = lib.mkIf config.services.transmission.enable ''
    server {
      listen 80;

      # server names for this server.
      # any requests that come in that match any these names will use the proxy.
      server_name plex.jb55.com;

      # this is where everything cool happens (you probably don't need to change anything here):
      location / {
        # if a request to / comes in, 301 redirect to the main plex page.
        # but only if it doesn't contain the X-Plex-Device-Name header
        # this fixes a bug where you get permission issues when accessing the web dashboard

        if ($http_x_plex_device_name = \'\') {
          rewrite ^/$ http://$http_host/web/index.html;
        }

        # set some headers and proxy stuff.
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_redirect off;

        # include Host header
        proxy_set_header Host $http_host;

        # proxy request to plex server
        proxy_pass http://127.0.0.1:32400;
      }
    }

    server {
      listen 80;
      server_name torrents.jb55.com;

      location / {
        proxy_read_timeout 300;
        proxy_pass_header  X-Transmission-Session-Id;
        proxy_set_header   X-Forwarded-Host   $host;
        proxy_set_header   X-Forwarded-Server $host;
        proxy_set_header   X-Forwarded-For    $proxy_add_x_forwarded_for;
        proxy_pass         http://127.0.0.1:${toString config.services.transmission.port}/transmission/web/;
      }

      location /rpc {
        proxy_pass         http://127.0.0.1:${toString config.services.transmission.port}/transmission/rpc;
      }

      location /upload {
        proxy_pass         http://127.0.0.1:${toString config.services.transmission.port}/transmission/upload;
      }
    }
  '';


  networking.defaultMailServer = {
    directDelivery = true;
    hostName = "smtp.jb55.com:587";
    domain = "jb55.com";
    useSTARTTLS = true;
    authUser = "jb55@jb55.com";
    authPass = extra.private.mailpass;
  };

}
