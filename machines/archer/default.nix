extra:
{ config, lib, pkgs, ... }:
let extras = rec { ztip = "10.243.14.20";
                   nix-serve = {
                     port = 10845;
                     bindAddress = ztip;
                   };
                 };
in {
  imports = [
    ./hardware
    (import ./nginx (extra // extras))
    (import ./trendbot extra)
  ];

  systemd.services.postgrest = {
    enable = true;
    description = "PostgREST";

    wantedBy = [ "multi-user.target" ];
    after =    [ "postgresql.service" ];

    serviceConfig.Type = "simple";
    serviceConfig.ExecStart = ''
      ${pkgs.haskellPackages.postgrest}/bin/postgrest \
        'postgres://pg-dev-zero.monstercat.com/Monstercat' \
        -a jb55 \
        +RTS -N -I2
    '';
  };

  services.namecoind.enable = false;
  services.namecoind.wallet = "/home/jb55/.namecoin/wallet.dat";
  services.namecoind.userFile = "/home/jb55/.namecoin/user";

  services.mongodb.enable = true;
  services.redis.enable = true;
  services.gitlab.enable = false;
  services.gitlab.databasePassword = "gitlab";

  services.nix-serve.enable = true;
  services.nix-serve.bindAddress = extras.nix-serve.bindAddress;
  services.nix-serve.port = extras.nix-serve.port;

  services.footswitch = {
    enable = true;
    enable-led = true;
    led = "input3::scrolllock";
  };

  networking.firewall.trustedInterfaces = ["zt0" "zt1"];
  networking.firewall.allowedTCPPorts = [ 22 143 80 ];

  services.fcgiwrap.enable = true;

  services.postfix = {
    enable = true;
    setSendmail = true;
  };

  services.postgresql = {
    dataDir = "/var/db/postgresql/9.5/";
    enable = true;
    # extraPlugins = with pkgs; [ pgmp ];
    authentication = pkgs.lib.mkForce ''
      # type db  user address        method
      local  all all                 trust
      host   all all  10.243.0.0/16  trust
      host   all all  192.168.1.0/16 trust

    '';
    extraConfig = ''
      listen_addresses = '10.243.14.20,192.168.1.49'
    '';
  };
}
