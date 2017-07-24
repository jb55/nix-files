extra:
{ config, lib, pkgs, ... }:
let notify = pkgs.callPackage (pkgs.fetchFromGitHub {
                      owner = "jb55";
                      repo = "imap-notify";
                      rev = "c0936c0bb4b7e283bbfeccdbac77f4cb50f71b3b";
                      sha256 = "19vadvnkg6bjp1607nlawdx1x07xnbbx7bgk66rbwrs4vhkvarkg";
                    }) {};
    penv = pkgs.python2.withPackages (ps: with ps; [ dbus-python pygobject2 ]);
    email-switcher = pkgs.writeScript "email-switcher" ''
      #!${penv}/bin/python2 -u

      import dbus
      import datetime
      import gobject
      import os
      from dbus.mainloop.glib import DBusGMainLoop

      def start_work():
        print("starting work notifier")
        os.system("systemctl stop    --user home-email-notifier")
        os.system("systemctl restart --user work-email-notifier")

      def start_home():
        print("starting home notifier")
        os.system("systemctl stop    --user work-email-notifier")
        os.system("systemctl restart --user home-email-notifier")

      def check():
        now = datetime.datetime.now()
        if now.isoweekday() > 5:
          start_home()
        else:
          if now.hour > 17 or now.hour < 9:
            start_home()
          else:
            start_work()

      def handle_sleep_callback(sleeping):
        if not sleeping:
          # awoke from sleep
          check()

      DBusGMainLoop(set_as_default=True) # integrate into main loob
      bus = dbus.SystemBus()             # connect to dbus system wide
      bus.add_signal_receiver(           # defince the signal to listen to
          handle_sleep_callback,            # name of callback function
          'PrepareForSleep',                 # signal name
          'org.freedesktop.login1.Manager',   # interface
          'org.freedesktop.login1'            # bus name
      )

      loop = gobject.MainLoop()          # define mainloop
      check()
      loop.run()
    '';

    notifier = user: pass: cmd: host: extra.util.writeBash "notifier" ''
      set -e

      arg="${host}"
      host=''${arg:-8.8.8.8}

      # wait for connectivity
      until /var/run/wrappers/bin/ping -c1 $host &>/dev/null; do :; done

      # run it once first in case we missed any from lost connectivity
      ${cmd} no || :
      ${notify}/bin/imap-notify ${user} ${pass} ${cmd} ${host}
    '';
in
with extra; {
  systemd.user.services.work-email-notifier = {
    enable = true;
    description = "work notifier";

    path = with pkgs; [ twmn eject isync notmuch bash ];

    serviceConfig.Type = "simple";
    serviceConfig.Restart = "always";
    serviceConfig.ExecStart =
      let cmd = util.writeBash "notify-cmd"  ''
            set -e
            export HOME=/home/jb55
            export DATABASEDIR=$HOME/mail/work
            (
              flock -x -w 100 200 || exit 1
              mbsync gmail
              notmuch new
              [ "$1" != "no" ] && \
              twmnc -i new_email -s 32 --pos top_left
            ) 200>/tmp/email-notify.lock
          '';
      in notifier private.work-email-user private.work-email-pass cmd "";
  };

  systemd.user.services.home-email-notifier = {
    enable = true;
    description = "home notifier";

    environment = {
      IMAP_ALLOW_UNAUTHORIZED = "1";
    };

    path = with pkgs; [ twmn eject muchsync notmuch bash openssh ];

    serviceConfig.Type = "simple";
    serviceConfig.Restart = "always";
    serviceConfig.ExecStart =
      let cmd = util.writeBash "notify-cmd" ''
            set -e
            export HOME=/home/jb55
            export DATABASEDIR=$HOME/mail/personal
            (
              flock -x -w 100 200 || exit 1
              muchsync -C ~/.notmuch-config-personal notmuch
              [ "$1" != "no" ] && \
              twmnc -i new_email -c p -s 32 --pos top_left
            ) 200>/tmp/email-notify.lock
          '';
      in notifier "jb55@jb55.com" private.personal-email-pass cmd "imap.jb55.com";
  };

  systemd.user.services.email-notify-switcher = {
    enable = true;
    description = "switches email notifier based on time";

    path = with pkgs; [ systemd ];

    wantedBy = [ "default.target" ];
    after    = [ "default.target" ];

    serviceConfig.ExecStart = "${email-switcher}";
  };

}
