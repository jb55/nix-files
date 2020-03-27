extra:
{ config, lib, pkgs, ... }:
let
  chromecastIP = "192.168.86.190";
  iptables = "iptables -A nixos-fw";
  ipr = "${pkgs.iproute}/bin/ip";
  writeBash = extra.util.writeBash;
  transmission-dir = "/zbig/torrents";
  download-dir = "${transmission-dir}/Downloads";
  openTCP = dev: port: ''
    ip46tables -A nixos-fw -i ${dev} -p tcp --dport ${toString port} -j nixos-fw-accept
  '';

in
{
  networking.hostId = extra.machine.hostId;

  networking.firewall.trustedInterfaces = ["zt1"];
  networking.firewall.allowedTCPPorts = [ 5000 5432 9735 9736 80 53 24800 ];
  networking.firewall.allowedUDPPorts = [ 53 ];

  networking.firewall.extraCommands = ''
    ${openTCP "ztrtaygmfr" 6533}
    ${openTCP "ztrtaygmfr" 6532}
    ${openTCP "ztrtaygmfr" 7878}
    ${openTCP "ztrtaygmfr" 7879}
    ${openTCP "ztrtaygmfr" 50001}
  '';

  services.transmission = {
    enable = true;
    home = transmission-dir;
    settings = {
      incomplete-dir-enable = true;
      rpc-whitelist = "127.0.0.1";
    };

    port = 14325;
  };

  services.plex = {
    enable = false;
    group = "transmission";
    openFirewall = true;
  };

  services.xinetd.enable = true;
  services.xinetd.services =
  [
    { name = "gopher";
      port = 70;
      server = "${pkgs.gophernicus}/bin/in.gophernicus";
      serverArgs = "-nf -r /var/gopher";
      extraConfig = ''
        disable = no
        env = PATH=${pkgs.coreutils}/bin:${pkgs.curl}/bin
        passenv = PATH
      '';
    }
  ];

  services.nginx.httpConfig = lib.mkIf config.services.transmission.enable ''
    server {
      listen 80;
      listen ${extra.machine.ztip}:80;
      listen 192.168.86.26;

      # server names for this server.
      # any requests that come in that match any these names will use the proxy.
      server_name plex.jb55.com plez.jb55.com media.home plex.home;

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
        proxy_set_header Host $host;

        # proxy request to plex server
        proxy_pass http://127.0.0.1:32400;
      }
    }

    server {
      listen 80;
      listen ${extra.machine.ztip}:80;
      listen 192.168.86.26;
      server_name torrents.jb55.com torrentz.jb55.com torrents.home torrent.home;

      location = /download {
        return 301 " /download/";
      }

      location /download/ {
        alias ${download-dir}/;
        autoindex on;
      }

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

}
