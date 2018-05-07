{ ... }: {
  # This file was populated at runtime with the networking
  # details gathered from the active system.
  networking = {
    nameservers = [
      "67.207.67.3"
      "67.207.67.2"
    ];
    defaultGateway = "159.89.128.1";
    defaultGateway6 = "";
    interfaces = {
      eth0 = {
        ip4 = [
          { address="159.89.143.225"; prefixLength=20; }
          { address="10.46.0.5"; prefixLength=16; }
        ];
        ip6 = [
          { address="fe80::e817:77ff:fe32:1c20"; prefixLength=64; }
        ];
      };
    };
  };
  services.udev.extraRules = ''
    ATTR{address}=="ea:17:77:32:1c:20", NAME="eth0"
  '';
}
