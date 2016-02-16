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

  systemd.services.massager.enable = true;
}
