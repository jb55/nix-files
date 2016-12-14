extra:
{ config, lib, pkgs, ... }:
let
  monstercatpkgs = import <monstercatpkgs> {};
  payments-processor = monstercatpkgs.payments-processor
  payment-scripts = monstercatpkgs.payment-scripts;
in
{
  systemd.services.payments-runner = {
    description = "Monstercat Payment Processor Runner";

    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" "redis.service" "postgresql.service" ];

    environment = with extra.private; {
      VIRTUAL_SHEET_DRIVE_ROOT = "/tmp/virtual-sheet-drive";
      PG_CS = "postgresql://jb55@db.zero.monster.cat/Monstercat";
      PAYMENT_PARSER_DIR = "${payments-processor}/share/parsers";
    };

    serviceConfig.ExecStart = "${payment-scripts}/bin/payment-runner";
    serviceConfig.Restart = "always";
    unitConfig.OnFailure = "notify-failed@%n.service";
  };
}
