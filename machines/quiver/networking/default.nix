extra:
{ config, lib, pkgs, ... }:
let
  chromecastIPs = [ "192.168.86.190" "192.168.1.67" "192.168.1.29" ];
  iptables = "iptables -A nixos-fw";
  openChromecast = ip: ''
    ${iptables} -p udp -s ${ip} -j nixos-fw-accept
    ${iptables} -p tcp -s ${ip} -j nixos-fw-accept
  '';
  ipr = "${pkgs.iproute}/bin/ip";
  writeBash = extra.util.writeBash;
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

in
{
  # networking.nameservers = [ "8.8.8.8" "8.8.4.4" ];

  networking.firewall.extraCommands = ''
    ${lib.concatStringsSep "\n\n" (map openChromecast chromecastIPs)}
  ''
  # openvpn-pia stuff, we only want to do this once
  + (if config.services.openvpn.servers.pia != null then ''
    # mangle packets in cgroup with a mark
    iptables -t mangle -A OUTPUT -m cgroup --cgroup 11 -j MARK --set-mark 11

    # NAT packets in cgroup through VPN tun interface
    iptables -t nat -A POSTROUTING -m cgroup --cgroup 11 -o tun0 -j MASQUERADE

    # create separate routing table
    ${ipr} rule add fwmark 11 table ${vpn.table}

    # add fallback route that blocks traffic, should the VPN go down
    ${ipr} route add blackhole default metric 2 table ${vpn.table}
  '' else "");

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
}
