{ config, lib, pkgs, ... }:
{
  systemd.services.massager = {
    description = "Massager service";
    wantedBy = [ "multi-user.target" ];
    after = [ "mongodb.target" ];

    serviceConfig = {
      Type = "simple";

      WorkingDirectory = "${pkgs.haskellPackages.massager-service}/bin";
      ExecStart = "${pkgs.haskellPackages.massager-service}/bin/massager-service";
    };
    restartIfChanged = false;

    preStart = ''
      ${pkgs.mongodb}/bin/mongo massager --eval 'db.User.remove({ name: null })'
    '';
  };

  services.postgresql = {
    dataDir = "/var/db/postgresql/9.5/";
    enable = true;
    authentication = pkgs.lib.mkForce ''
      # type db  user address        method
      local  all all                 trust
      host   all all  10.243.0.0/16  trust
    '';
    extraConfig = ''
      listen_addresses = '10.243.14.20'
    '';
  };

  systemd.services.massager.enable = true;
}
