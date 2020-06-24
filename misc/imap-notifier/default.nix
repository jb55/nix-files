extra:
{ config, lib, pkgs, ... }:
let notify = pkgs.callPackage (pkgs.fetchFromGitHub {
                      owner = "jb55";
                      repo = "imap-notify";
                      rev = "c0936c0bb4b7e283bbfeccdbac77f4cb50f71b3b";
                      sha256 = "19vadvnkg6bjp1607nlawdx1x07xnbbx7bgk66rbwrs4vhkvarkg";
                    }) {};
    penv = pkgs.python2.withPackages (ps: with ps; [ dbus-python pygobject2 ]);
    awake-from-sleep-fetcher = pkgs.writeScript "awake-from-sleep-fetcher" ''
      #!${penv}/bin/python2 -u

      import dbus
      import datetime
      import gobject
      import os
      from dbus.mainloop.glib import DBusGMainLoop

      def start_home():
        print("starting email fetcher")
        os.system("systemctl restart --user email-fetcher")

      def handle_sleep_callback(sleeping):
        if not sleeping:
          # awoke from sleep
          start_home()

      DBusGMainLoop(set_as_default=True) # integrate into main loob
      bus = dbus.SystemBus()             # connect to dbus system wide
      bus.add_signal_receiver(           # defince the signal to listen to
          handle_sleep_callback,            # name of callback function
          'PrepareForSleep',                 # signal name
          'org.freedesktop.login1.Manager',   # interface
          'org.freedesktop.login1'            # bus name
      )

      loop = gobject.MainLoop()          # define mainloop
      loop.run()
    '';

    notifier = user: pass: cmd: host: extra.util.writeBash "notifier" ''
      set -e

      arg="${host}"

      # wait for connectivity
      until ${pkgs.libressl.nc}/bin/nc -w 1 -vz jb55.com 12566 &>/dev/null; do sleep 1; done

      # run it once first in case we missed any from lost connectivity
      ${cmd} || :
      export IMAP_NOTIFY_USER=${user}
      export IMAP_NOTIFY_PASS=${pass}
      export IMAP_NOTIFY_CMD=${cmd}
      export IMAP_NOTIFY_HOST=${host}
      exec ${notify}/bin/imap-notify
    '';
in
with extra; {
  systemd.user.services.email-fetcher = {
    enable = if extra.is-minimal then false else true;
    description = "email fetcher";

    environment = {
      IMAP_ALLOW_UNAUTHORIZED = "0";
      IMAP_NOTIFY_PORT = "12788";
    };

    path = with pkgs; [ eject utillinux muchsync notmuch bash openssh ];

    serviceConfig.Type = "simple";
    serviceConfig.Restart = "always";
    serviceConfig.ExecStart =
      let cmd = util.writeBash "email-fetcher" ''
            set -e
            export HOME=/home/jb55
            export DATABASEDIR=$HOME/mail/personal

            notify() {
              local c=$(notmuch --config /home/jb55/.notmuch-config-personal count 'tag:inbox and not tag:filed and not tag:noise')
              local lc=$c
              if [ -f /tmp/last-email-count ]; then
                lc=$(</tmp/last-email-count)
              fi
              echo "$c" > /tmp/last-email-count
              if [ -f ~/var/notify/home ] && [ $c -ne $lc ]; then
                ${pkgs.libnotify}/bin/notify-send -i email-new "You Got Mail (inbox $c)"
              fi
            }

            (
              flock -x -w 100 200 || exit 1
              if [ -f ~/var/notify/home ]; then
                ${pkgs.libnotify}/bin/notify-send -i email-new "Fetching new mail..."
              fi
              muchsync -C ~/.notmuch-config-personal notmuch
              notify
            ) 200>/tmp/email-notify.lock
          '';
      in notifier "jb55@jb55.com" private.personal-email-pass cmd "jb55.com";
  };

  systemd.user.services.awake-from-sleep-fetcher = {
    enable = if extra.is-minimal then false else true;
    description = "";

    path = with pkgs; [ systemd ];

    wantedBy = [ "default.target" ];
    after    = [ "default.target" ];

    serviceConfig.ExecStart = "${awake-from-sleep-fetcher}";
  };

}
