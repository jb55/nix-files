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
        remote 104.200.132.180 1194
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
        comp-lzo no

        remote-cert-tls server

        auth-user-pass ${vpn.credfile}
        route-noexec
        route-up ${vpn.routeup}

        # Compress-lzo is not compactible with 2.3 clients so using deprecated comp-lzo
        verb 3
        pull
        fast-io
        cipher AES-256-CBC
        auth SHA512

        <ca>
        -----BEGIN CERTIFICATE-----
        MIIFCjCCAvKgAwIBAgIBATANBgkqhkiG9w0BAQ0FADA5MQswCQYDVQQGEwJQQTEQ
        MA4GA1UEChMHTm9yZFZQTjEYMBYGA1UEAxMPTm9yZFZQTiBSb290IENBMB4XDTE2
        MDEwMTAwMDAwMFoXDTM1MTIzMTIzNTk1OVowOTELMAkGA1UEBhMCUEExEDAOBgNV
        BAoTB05vcmRWUE4xGDAWBgNVBAMTD05vcmRWUE4gUm9vdCBDQTCCAiIwDQYJKoZI
        hvcNAQEBBQADggIPADCCAgoCggIBAMkr/BYhyo0F2upsIMXwC6QvkZps3NN2/eQF
        kfQIS1gql0aejsKsEnmY0Kaon8uZCTXPsRH1gQNgg5D2gixdd1mJUvV3dE3y9FJr
        XMoDkXdCGBodvKJyU6lcfEVF6/UxHcbBguZK9UtRHS9eJYm3rpL/5huQMCppX7kU
        eQ8dpCwd3iKITqwd1ZudDqsWaU0vqzC2H55IyaZ/5/TnCk31Q1UP6BksbbuRcwOV
        skEDsm6YoWDnn/IIzGOYnFJRzQH5jTz3j1QBvRIuQuBuvUkfhx1FEwhwZigrcxXu
        MP+QgM54kezgziJUaZcOM2zF3lvrwMvXDMfNeIoJABv9ljw969xQ8czQCU5lMVmA
        37ltv5Ec9U5hZuwk/9QO1Z+d/r6Jx0mlurS8gnCAKJgwa3kyZw6e4FZ8mYL4vpRR
        hPdvRTWCMJkeB4yBHyhxUmTRgJHm6YR3D6hcFAc9cQcTEl/I60tMdz33G6m0O42s
        Qt/+AR3YCY/RusWVBJB/qNS94EtNtj8iaebCQW1jHAhvGmFILVR9lzD0EzWKHkvy
        WEjmUVRgCDd6Ne3eFRNS73gdv/C3l5boYySeu4exkEYVxVRn8DhCxs0MnkMHWFK6
        MyzXCCn+JnWFDYPfDKHvpff/kLDobtPBf+Lbch5wQy9quY27xaj0XwLyjOltpiST
        LWae/Q4vAgMBAAGjHTAbMAwGA1UdEwQFMAMBAf8wCwYDVR0PBAQDAgEGMA0GCSqG
        SIb3DQEBDQUAA4ICAQC9fUL2sZPxIN2mD32VeNySTgZlCEdVmlq471o/bDMP4B8g
        nQesFRtXY2ZCjs50Jm73B2LViL9qlREmI6vE5IC8IsRBJSV4ce1WYxyXro5rmVg/
        k6a10rlsbK/eg//GHoJxDdXDOokLUSnxt7gk3QKpX6eCdh67p0PuWm/7WUJQxH2S
        DxsT9vB/iZriTIEe/ILoOQF0Aqp7AgNCcLcLAmbxXQkXYCCSB35Vp06u+eTWjG0/
        pyS5V14stGtw+fA0DJp5ZJV4eqJ5LqxMlYvEZ/qKTEdoCeaXv2QEmN6dVqjDoTAo
        k0t5u4YRXzEVCfXAC3ocplNdtCA72wjFJcSbfif4BSC8bDACTXtnPC7nD0VndZLp
        +RiNLeiENhk0oTC+UVdSc+n2nJOzkCK0vYu0Ads4JGIB7g8IB3z2t9ICmsWrgnhd
        NdcOe15BincrGA8avQ1cWXsfIKEjbrnEuEk9b5jel6NfHtPKoHc9mDpRdNPISeVa
        wDBM1mJChneHt59Nh8Gah74+TM1jBsw4fhJPvoc7Atcg740JErb904mZfkIEmojC
        VPhBHVQ9LHBAdM8qFI2kRK0IynOmAZhexlP/aT/kpEsEPyaZQlnBn3An1CRz8h0S
        PApL8PytggYKeQmRhl499+6jLxcZ2IegLfqq41dzIjwHwTMplg+1pKIOVojpWA==
        -----END CERTIFICATE-----
        </ca>
        key-direction 1
        <tls-auth>
        #
        # 2048 bit OpenVPN static key
        #
        -----BEGIN OpenVPN Static key V1-----
        e685bdaf659a25a200e2b9e39e51ff03
        0fc72cf1ce07232bd8b2be5e6c670143
        f51e937e670eee09d4f2ea5a6e4e6996
        5db852c275351b86fc4ca892d78ae002
        d6f70d029bd79c4d1c26cf14e9588033
        cf639f8a74809f29f72b9d58f9b8f5fe
        fc7938eade40e9fed6cb92184abb2cc1
        0eb1a296df243b251df0643d53724cdb
        5a92a1d6cb817804c4a9319b57d53be5
        80815bcfcb2df55018cc83fc43bc7ff8
        2d51f9b88364776ee9d12fc85cc7ea5b
        9741c4f598c485316db066d52db4540e
        212e1518a9bd4828219e24b20d88f598
        a196c9de96012090e333519ae18d3509
        9427e7b372d348d352dc4c85e18cd4b9
        3f8a56ddb2e64eb67adfc9b337157ff4
        -----END OpenVPN Static key V1-----
        </tls-auth>
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
  systemd.services.transmission.serviceConfig.User = lib.mkForce "root";
  systemd.services.transmission.serviceConfig.ExecStart = lib.mkForce (
    writeBash "start-transmission-under-vpn" ''
      exec ${pkgs.libcgroup}/bin/cgexec --sticky -g net_cls:pia \
      ${pkgs.sudo}/bin/sudo -u transmission \
      ${pkgs.transmission}/bin/transmission-daemon \
        -f \
        --port ${toString config.services.transmission.port};
    ''
  );


}
