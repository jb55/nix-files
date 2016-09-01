extra:
{ config, lib, pkgs, ... }:
let tunecore-trend-bot = import (pkgs.fetchurl {
      url = https://jb55.com/s/655208fa649caddf.nix;
      sha1 = "655208fa649caddf5be1049f4edc17bf6b1aa2ef";
    }) { inherit pkgs; };
in
{
  systemd.services."notify-failed@" = {
    description = "Job failure notifier";

    serviceConfig.ExecStart = let script = pkgs.writeScript "trend-bot-fail" ''
      #!${pkgs.bash}/bin/bash

      UNIT=$1

      /var/setuid-wrappers/sendmail -t <<ERRMAIL
      To: bill@monstercat.com
      From: systemd <root@$HOSTNAME>
      Subject: $UNIT Failed
      Content-Transfer-Encoding: 8bit
      Content-Type: text/plain; charset=UTF-8

      $2
      $3
      $4

      $(systemctl status $UNIT)
      ERRMAIL
    '';
    in "${script} %I 'Hostname: %H' 'Machine ID: %m' 'Boot ID: %b'";

  };

  systemd.services.trend-bot = {
    enable = true;

    description = "tc trend bot";

    wantedBy = [ "multi-user.target" ];
    after    = [ "network-online.target" "postgresql.service" ];

    environment = {
      TC_PASS = extra.private.tc-pass;
    };

    serviceConfig.Type = "oneshot";
    serviceConfig.ExecStart = pkgs.writeScript "trend-bot" ''
      #!${pkgs.bash}/bin/bash
      day=$(date "--date=today -3 days" +%F)
      sqlq=$(cat <<EOF
      BEGIN;
      DELETE FROM tunecore_trends WHERE period = '$day';
      COPY tunecore_trends FROM STDIN CSV;
      COMMIT;
      EOF
      )

      sql () {
        ${pkgs.postgresql}/bin/psql 'postgresql://jb55@pg-dev-zero.monstercat.com/Monstercat' -c "$1"
      }

      ${tunecore-trend-bot}/bin/tunecore-trend-bot $day $day | \
        ${pkgs.gnused}/bin/sed 1d | \
        sql "$sqlq"

      items=$(sql "select count(*) as count from tunecore_trends where period = '$day'" | sed '1,2d;4,10d;s/^\s//g')

      if [ "$items" -lt "37000" ]; then
        # should be around ~40k line items as of 2016-08-29
        echo "got $items lines, which is less than the required 37000 items"
        exit 1;
      fi
    '';

    unitConfig.OnFailure = "notify-failed@%n.service";

    restartIfChanged = false;
    startAt = "*-*-* 23:59:00";
  };
}

