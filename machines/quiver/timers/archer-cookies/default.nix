extra:
{ config, lib, pkgs, ... }:
let
  util = extra.util;
in
{

  systemd.user.services.cookie-bot = {
    description = "copy cookies to archer";

    path = with pkgs; [ openssh ];

    serviceConfig.ExecStart = util.writeBash "cp-cookies" ''
      export HOME=/home/jb55
      PTH=".config/chromium/Default/Cookies"
      scp $HOME/$PTH archer:$PTH
    '';
    unitConfig.OnFailure = "notify-failed-user@%n.service";

    # youtube bot is run on the 20th at 10:24:00
    startAt = "*-*-20 09:24:00";
  };

  systemd.user.services.cookie-bot-reminder = {
    description = "reminder to login";

    serviceConfig.ExecStart = util.writeBash "cookie-reminder" ''
      /run/wrappers/bin/sendmail -f bill@monstercat.com <<EOF
      To: bill@monstercat.com
      From: THE COOKIE MONSTER <cookiemonster@quiver>
      Subject: reminder to log into YouTube cms

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
