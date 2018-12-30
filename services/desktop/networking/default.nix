extra:
{ config, lib, pkgs, ... }:
let
  chromecastIP = "192.168.86.190";
  iptables = "iptables -A nixos-fw";
  ipr = "${pkgs.iproute}/bin/ip";
  writeBash = extra.util.writeBash;
  vpn = {
    name = "pia";
    table = "300";
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

in
{
  #networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];

  networking.firewall.extraCommands =
    # openvpn stuff, we only want to do this once
    if config.services.openvpn.servers.pia != null then ''
      # mangle packets in cgroup with a mark
      iptables -t mangle -A OUTPUT -m cgroup --cgroup 11 -j MARK --set-mark 11

      # NAT packets in cgroup through VPN tun interface
      iptables -t nat -A POSTROUTING -m cgroup --cgroup 11 -o tun0 -j MASQUERADE

      # create separate routing table
      ${ipr} rule add fwmark 11 table ${vpn.table}

      # add fallback route that blocks traffic, should the VPN go down
      ${ipr} route add blackhole default metric 2 table ${vpn.table}
    '' else "";

  users.extraGroups.vpn-pia.members = [ "jb55" "transmission" ];
  systemd.services.openvpn-pia.path = [ pkgs.libcgroup ];
  services.openvpn.servers = {
    pia = {
      autoStart = true;

      config = ''
        client
        dev tun
        proto udp
        remote 185.153.179.9 1194
        resolv-retry infinite
        remote-random
        nobind
        tun-mtu 1500
        tun-mtu-extra 32
        mssfix 1450
        persist-key
        persist-tun
        ping 15
        ping-restart 0
        ping-timer-rem
        reneg-sec 0
        explicit-exit-notify 3

        remote-cert-tls server

        #mute 10000
        auth-user-pass ${vpn.credfile}

        comp-lzo
        verb 3
        pull
        fast-io
        cipher AES-256-CBC
        auth SHA512

        <ca>
        -----BEGIN CERTIFICATE-----
        MIIExzCCA6+gAwIBAgIJAOPEhSAzJHDIMA0GCSqGSIb3DQEBCwUAMIGdMQswCQYD
        VQQGEwJQQTELMAkGA1UECBMCUEExDzANBgNVBAcTBlBhbmFtYTEQMA4GA1UEChMH
        Tm9yZFZQTjEQMA4GA1UECxMHTm9yZFZQTjEZMBcGA1UEAxMQY2E5NC5ub3JkdnBu
        LmNvbTEQMA4GA1UEKRMHTm9yZFZQTjEfMB0GCSqGSIb3DQEJARYQY2VydEBub3Jk
        dnBuLmNvbTAeFw0xNzA0MjAxMTE4NDdaFw0yNzA0MTgxMTE4NDdaMIGdMQswCQYD
        VQQGEwJQQTELMAkGA1UECBMCUEExDzANBgNVBAcTBlBhbmFtYTEQMA4GA1UEChMH
        Tm9yZFZQTjEQMA4GA1UECxMHTm9yZFZQTjEZMBcGA1UEAxMQY2E5NC5ub3JkdnBu
        LmNvbTEQMA4GA1UEKRMHTm9yZFZQTjEfMB0GCSqGSIb3DQEJARYQY2VydEBub3Jk
        dnBuLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAKpFRsSPZsq6
        EQBIRZeHL6xxOZY2z5P2yraIUU39+J6R5GTwcUbOSd9ufxRfE0/CszT8QP5f4qyE
        mxYhMxswN+XfMN8Mmb2zNU6PWmPFlYgzkwPedmd2yHHkBiS3LlA1S0OzTbd3pO9B
        K9XV72LMQpyhcU+0SI4xlG6Q3AhyotVNIZfcpwqa3iODV3Ho/xKwRc3MTMDAP+ze
        vxR7QyBIDqmUY0wLf94vL8YlfwoVF0DvJ7k0fXX4anUBt6XVzKtqiV9shbPHixGI
        CyBwsEUFTuQNrNVw9mRF3KqeoEAWTQaNZClswWpLT8OZyg1jzmVM+Uk3ihkJL7kn
        q0kL3qYn0JkCAwEAAaOCAQYwggECMB0GA1UdDgQWBBQu53WFpw5k+Q1V7g+rQT5w
        ehBzKDCB0gYDVR0jBIHKMIHHgBQu53WFpw5k+Q1V7g+rQT5wehBzKKGBo6SBoDCB
        nTELMAkGA1UEBhMCUEExCzAJBgNVBAgTAlBBMQ8wDQYDVQQHEwZQYW5hbWExEDAO
        BgNVBAoTB05vcmRWUE4xEDAOBgNVBAsTB05vcmRWUE4xGTAXBgNVBAMTEGNhOTQu
        bm9yZHZwbi5jb20xEDAOBgNVBCkTB05vcmRWUE4xHzAdBgkqhkiG9w0BCQEWEGNl
        cnRAbm9yZHZwbi5jb22CCQDjxIUgMyRwyDAMBgNVHRMEBTADAQH/MA0GCSqGSIb3
        DQEBCwUAA4IBAQCQ7pdz6SH7IOcp5zGl63EhImhyvy6aD3c0J8XycGyh/DONFrj2
        ApdKuahny5ZfoZV+zP6NvaU3auoNGAGsRlOoCeY1edmevsCysC2umJKMtNBRNMTX
        51CTCDuM7jXZ6oNhy0F1XEeOFT+t9WpeNzab5vNuPclAR57WZzbwGYIHUV1wQyWj
        MTYfwcv0E9uNwF0r0y9NV5k63EyOvWRKjGy6YI7Tv1wtnyD+B10VaXBuRKge46fV
        tB83AkJwF00C+Dyy1BL4X1UmUAlusbz/YZnxq6HRJmrEY6+7p4+fOUbHCtM7Xtqf
        rjfKjYoPeoUnKSYDwx0GepuaSNVWtqEgHYyE
        -----END CERTIFICATE-----
        </ca>
        key-direction 1
        <tls-auth>
        -----BEGIN OpenVPN Static key V1-----
        da7b64ee7bb880f0783781e2bcb3d624
        76e55ecb0c525448c0844a0d03b66636
        8568db261ce272cdb7c65c623fdb4088
        82e5c608c28c3c36655c98cf7ebb5770
        1a987f7a689af9f86a283761fbbe1304
        8372cbb215f64054e48157059b71c167
        f50d8e9d1f0d9ae1902d51b7fae0d4b6
        1936398446999b4b5e51f374e66d77c6
        205cb63372b2ef820e3d415547317726
        d70bd6ea1e67ea35055f1026197bbed4
        7a3211703da08b851a96d6b02fc05b0d
        bb76eeabaa62969b4b5025dbe68580c8
        df950ede15f5a7a845aa97f4a43da8b7
        0810a3c87af1ca8c95327c72b80871d1
        fa31da4e31fffb7119b99c7a847f9c59
        8480ea742b8a7b91bf521ec0987ba03d
        -----END OpenVPN Static key V1-----
        </tls-auth>

        route-noexec
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

  systemd.services.transmission.requires = [ "openvpn-pia.service" ];
  systemd.services.transmission.after    = [ "openvpn-pia.service" ];
  #systemd.services.transmission.serviceConfig.User = lib.mkForce "root";
  systemd.services.transmission.serviceConfig.ExecStart = lib.mkForce (
    writeBash "start-transmission-under-vpn" ''
      ${pkgs.libcgroup}/bin/cgexec --sticky -g net_cls:pia \
      #${pkgs.sudo}/bin/sudo -u transmission \
      ${pkgs.transmission}/bin/transmission-daemon \
        -f \
        --port ${toString config.services.transmission.port};
    ''
  );


}
