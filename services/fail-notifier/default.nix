{ config, lib, pkgs, ... }:
{
  systemd.services."notify-failed@" = {
    description = "Job failure notifier";

    serviceConfig.ExecStart = let script = pkgs.writeScript "failure-notifier" ''
      #!${pkgs.bash}/bin/bash

      UNIT=$1

      /run/wrappers/bin/sendmail -f bill@monstercat.com -t <<ERRMAIL
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

  # todo: abstract
  systemd.user.services."notify-failed-user@" = {
    description = "Job failure notifier";

    serviceConfig.ExecStart = let script = pkgs.writeScript "failure-notifier" ''
      #!${pkgs.bash}/bin/bash

      UNIT=$1

      /run/wrappers/bin/sendmail -f bill@monstercat.com -t <<ERRMAIL
      To: bill@monstercat.com
      From: systemd <root@$HOSTNAME>
      Subject: user $UNIT Failed
      Content-Transfer-Encoding: 8bit
      Content-Type: text/plain; charset=UTF-8

      $2
      $3
      $4

      $(systemctl --user status $UNIT)
      ERRMAIL
    '';
    in "${script} %I 'Hostname: %H' 'Machine ID: %m' 'Boot ID: %b'";

  };

}
