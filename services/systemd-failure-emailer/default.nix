{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.systemd-failure-emailer;

in {

  options.services.systemd-failure-emailer = {
    enable = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = ''
        Enable timer-failure-emailer to send emails when systemd units fail
      '';
    };

  };

  config = mkIf cfg.enable {
    systemd.services.systemd-failure-emailer = {
      description = "Systemd service failure emailer";
      serviceConfig = {
        ExecStart = let script = pkgs.writeScript "failure-notifier" ''
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
    };
  };

}
