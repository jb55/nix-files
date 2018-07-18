extra:
{ config, lib, pkgs, ... }:
let
  util = extra.util;
in
{

  systemd.user.services.cookie-bot = {
    description = "copy cookies to archer";

    wantedBy = [ "default.target" ];
    after    = [ "default.target" ];

    path = with pkgs; [ openssh rsync ];

    serviceConfig.ExecStart = util.writeBash "cp-cookies" ''
      export HOME=/home/jb55
      PTH=".config/chromium/Default/Cookies"
      rsync -av $HOME/$PTH archer:$PTH
    '';
    unitConfig.OnFailure = "notify-failed-user@%n.service";

    startAt = [
      "*-*-20 09:24:00"       # youtube bot is run on the 20th at 10:24:00
      "Tue *-*-1..7 15:00:00" # cookies for itunes bot on the first tuesday
    ];
  };

  systemd.user.services.cookie-bot-reminder = {
    description = "reminder to login";

    wantedBy = [ "default.target" ];
    after    = [ "default.target" ];

    serviceConfig.ExecStart = util.writeBash "cookie-reminder" ''
      /run/wrappers/bin/sendmail -f bill@monstercat.com <<EOF
      To: bill@monstercat.com
      Cc: jb55@jb55.com
      From: THE COOKIE MONSTER <cookiemonster@quiver>
      Subject: Reminder to log into YouTube cms

      I'll be doing an rsync from quiver tomorrow at 10:24

      Here's a link for your convenience:

        https://cms.youtube.com

      Cheers,
        THE COOKIE MONSTER
      EOF
    '';
    unitConfig.OnFailure = "notify-failed-user@%n.service";

    startAt = "*-*-19 10:24:00";
  };

}
