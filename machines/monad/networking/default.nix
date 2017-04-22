extra:
{ config, lib, pkgs, ... }:
let
  chromecastIP = "192.168.86.190";
  iptables = "iptables -A nixos-fw";
  vpn = {
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
  };
  openTCP = dev: port: ''
    ip46tables -A nixos-fw -i ${dev} -p tcp --dport ${toString port} -j nixos-fw-accept
  '';

  piaConfig = pkgs.writeText "pia-openvpn.conf" config.services.openvpn.servers.pia.config;

  writeSh = fname: body: pkgs.writeScript fname ''
    #! /bin/sh
    ${body}
  '';
in
{
  networking.nameservers = [ "8.8.8.8" "8.8.4.4" ];

  networking.firewall.extraCommands = ''
    ${openTCP "zt2" 80}
    ${openTCP "zt1" 80}
    ${iptables} -p udp -s ${chromecastIP} -j nixos-fw-accept
    ${iptables} -p tcp -s ${chromecastIP} -j nixos-fw-accept
  '';

  systemd.services.openvpn-pia.serviceConfig = lib.mkForce {
    ExecStart = writeSh "openvpn-pia-start" ''
      ${pkgs.iproute}/bin/ip netns exec pia ${pkgs.openvpn}/sbin/openvpn --config ${piaConfig}
    '';
    ExecStartPre = writeSh "openvpn-pia-up" config.services.openvpn.servers.pia.up;
    ExecStop = writeSh "openvpn-pia-down" config.services.openvpn.servers.pia.down ;
    Type = "simple";
    Restart = "always";
  };

  services.openvpn.servers = {
    pia = rec {
      autoStart = false;

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
        verb 1
      '';

      up = ''
        ip netns add pia
        ip netns exec pia ip addr add 127.0.0.1/8 dev lo
        ip netns exec pia ip link set lo up

        ip link add vpn0 type veth peer name vpn1
        ip link set vpn0 up
        ip link set vpn1 netns pia up
        ip addr add 10.200.200.1/24 dev vpn0
        ip netns exec pia ip addr add 10.200.200.2/24 dev vpn1
        ip netns exec pia ip route add default via 10.200.200.1 dev vpn1

        iptables -A INPUT \! -i vpn0 -s 10.200.200.0/24 -j DROP
        iptables -t nat -A POSTROUTING -s 10.200.200.0/24 -o en+ -j MASQUERADE

        echo 1 > /proc/sys/net/ipv4/ip_forward

        mkdir -p /etc/netns/pia
        echo 'nameserver 8.8.8.8' > /etc/netns/pia/resolv.conf

        ip netns exec pia ${lib.getBin pkgs.fping}/bin/fping -q www.google.ca
      '';

      down = ''
        rm -rf /etc/netns/pia

        echo 0 > /proc/sys/net/ipv4/ip_forward

        iptables -D INPUT \! -i vpn0 -s 10.200.200.0/24 -j DROP
        iptables -t nat -D POSTROUTING -s 10.200.200.0/24 -o en+ -j MASQUERADE

        ip netns delete pia
      '';
    };
  };

  services.transmission = {
    enable = true;
    settings = {
      download-dir = "/sand/torrents/downloads";
      incomplete-dir = "/sand/torrents/.incomplete";
      incomplete-dir-enable = true;
      rpc-whitelist = "10.200.200.1";
    };

    port = 14325;
  };

  systemd.services.transmission.after = [ "openvpn.service" ];
  systemd.services.transmission.serviceConfig.User = lib.mkForce "root";
  systemd.services.transmission.serviceConfig.ExecStart = lib.mkForce (
    writeSh "start-transmission-under-vpn" ''
      ${pkgs.iproute}/bin/ip netns exec pia \
        ${pkgs.sudo}/bin/sudo -u transmission \
          ${pkgs.transmission}/bin/transmission-daemon \
            -f \
            --port ${toString config.services.transmission.port};
    ''
  );

  networking.defaultMailServer = {
    directDelivery = true;
    hostName = "smtp.jb55.com:587";
    domain = "jb55.com";
    useSTARTTLS = true;
    authUser = "jb55@jb55.com";
    authPass = extra.private.mailpass;
  };

}
