{ config, lib, pkgs, ... }:
{
  systemd.services."notify-failed@" = {
    description = "Job failure notifier";

    serviceConfig.ExecStart = let script = pkgs.writeScript "failure-notifier" ''
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

}
