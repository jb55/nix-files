{ config, lib, pkgs, ... }:
{
  systemd.services.massager = {
    description = "Massager service";
    serviceConfig = {
      Type = "simple";

      wantedBy = [ "multi-user.target" ];
      after = [ "mongodb.target" ];

      ExecStart = "${pkgs.haskellPackages.massager-service}/bin/massager-service";
    };
    restartIfChanged = false;
  };

  systemd.services.massager.enable = true;
}
