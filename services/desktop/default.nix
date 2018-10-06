{ composeKey, util, userConfig, theme, icon-theme, extra }:
{ config, lib, pkgs, ... }:
let
  clippings-pl-file = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/jb55/kindle-clippings/master/clippings.pl";
    sha256 = "13bn5lvm4p85369yj88jr62h3zalmmyrzmjc332qwlqgqhyf3dls";
  };
  clippings-pl = util.writeBash "clippings.pl" ''
    ${lib.getBin pkgs.perl}/bin/perl ${clippings-pl-file}
  '';
  clipmenu = pkgs.callPackage ../../nixpkgs/clipmenu {};

  secrets = extra.private;
in
{
  imports = [
    (import ./networking extra)
  ];

  services.gnome3.gnome-keyring.enable = true;

  services.trezord.enable = true;

  programs.gnupg.trezor-agent = {
    enable = true;
    configPath = "/home/jb55/.gnupg/trezor";
  };

  services.emacs.enable = true;
  services.emacs.install = true;

  systemd.user.services.emacs.path = with pkgs; [ bash nix ];
  systemd.user.services.emacs.serviceConfig.ExecStart =
    let
      cfg = config.services.emacs;
    in
      lib.mkForce (
        pkgs.writeScript "start-emacs" ''
          #!/usr/bin/env bash
          source ${config.system.build.setEnvironment}

          # hacky af
          export NIX_PATH=dotfiles=/home/jb55/dotfiles:jb55pkgs=/home/jb55/etc/jb55pkgs:monstercatpkgs=/home/jb55/etc/monstercatpkgs:nixos-config=/home/jb55/etc/nix-files:nixpkgs=/home/jb55/nixpkgs:/home/jb55/.nix-defexpr/channels:nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos:nixos-config=/etc/nixos/configuration.nix:/nix/var/nix/profiles/per-user/root/channels
          export NIXPKGS=/home/jb55/nixpkgs

          exec /home/jb55/bin/all-dev --run 'exec ${cfg.package}/bin/emacs --daemon';
        ''
      );

  services.redshift = {
    enable = true;
    # temperature.day = 5700;
    # temperature.night = 3700;

    brightness = {
      day = "1.0";
      night = "0.6";
    };

    latitude="49.270186";
    longitude="-123.109353";
  };

  systemd.user.services.udiskie =  {
    enable = true;
    description = "userspace removable drive automounter";
    after    = [ "multi-user.target" ];
    wants    = [ "multi-user.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${lib.getBin pkgs.udiskie}/bin/udiskie";
    };
  };

  systemd.user.services.kindle-sync3 = {
    enable = true;
    description = "sync kindle";
    after    = [ "media-kindle.mount" ];
    requires = [ "media-kindle.mount" ];
    wantedBy = [ "media-kindle.mount" ];
    serviceConfig = {
      ExecStart = util.writeBash "kindle-sync" ''
        export PATH=${lib.makeBinPath (with pkgs; [ coreutils eject perl dos2unix git ])}:$PATH
        NOTES=/home/jb55/doc/notes/kindle
        mkdir -p $NOTES
        </media/kindle/documents/My\ Clippings.txt dos2unix | \
          ${clippings-pl} > $NOTES/clippings.yml
        cd $NOTES
        if [ ! -d ".git" ]; then
          git init .
          git remote add origin gh:jb55/my-clippings
        fi
        git add clippings.yml
        git commit -m "update"
        git push -u origin master
      '';
    };
  };

  services.mpd = {
    enable = false;
    dataDir = "/home/jb55/mpd";
    user = "jb55";
    group = "users";
    extraConfig = ''
      audio_output {
        type     "pulse"
        name     "Local MPD"
        server   "127.0.0.1"
      }
    '';
  };

  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
    tcp = {
      enable = true;
      anonymousClients.allowedIpRanges = ["127.0.0.1"];
    };
  };

  services.mopidy.extensionPackages = with pkgs; [
    mopidy-spotify
    mopidy-spotify-tunigo
    mopidy-soundcloud
    mopidy-moped
  ];
  # why is all this such broken garbage
  services.mopidy.enable = false;
  services.mopidy.configuration = ''
    [spotify_tunigo]
    enabled = true
    spotify_tunigo/region = CA

    [spotify]
    enabled = true
    username = ${extra.private.spotify.username}
    password = ${extra.private.spotify.password}
    client_id = ${extra.private.spotify.client_id}
    client_secret = ${extra.private.spotify.client_secret}

    [http]
    enabled = true
    hostname = 127.0.0.1
    port = 6680
    static_dir =
    zeroconf = Mopidy HTTP server on $hostname

    [youtube]
    enabled = false

    [audio]
    mixer = software
    mixer_volume =
    output = pulsesink server=127.0.0.1
    buffer_time =

    [soundcloud]
    auth_token = ${extra.private.soundcloud.auth_token}

    [mpd]
    hostname = ::
  '';

  services.udev.extraRules = ''
    # yubikey neo
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1050", ATTRS{idProduct}=="0116", MODE="0666"

    # yubikey4
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1050", ATTRS{idProduct}=="0407", MODE="0666"

    # kindle
    ATTRS{idVendor}=="1949", ATTRS{idProduct}=="0004", SYMLINK+="kindle"
    ATTRS{idVendor}=="1949", ATTRS{idProduct}=="0003", SYMLINK+="kindledx"

    # HTC Vive HID Sensor naming and permissioning

    # vive hmd
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="0bb4", ATTRS{idProduct}=="2c87", TAG+="uaccess"

    # vive controller
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="28de", ATTRS{idProduct}=="2101", TAG+="uaccess"

    # vive lighthouse
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="28de", ATTRS{idProduct}=="2000", TAG+="uaccess"
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="28de", ATTRS{idProduct}=="1043", TAG+="uaccess"
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="28de", ATTRS{idProduct}=="2050", TAG+="uaccess"
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="28de", ATTRS{idProduct}=="2011", TAG+="uaccess"
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="28de", ATTRS{idProduct}=="2012", TAG+="uaccess"

    # vive audio
    KERNEL=="hidraw*", ATTRS{idVendor}=="0d8c", ATTRS{idProduct}=="0012", MODE="0666"


    SUBSYSTEM=="usb", ATTRS{idVendor}=="0bb4", ATTRS{idProduct}=="2c87", TAG+="uaccess"
    # HTC Camera USB Node
    SUBSYSTEM=="usb", ATTRS{idVendor}=="114d", ATTRS{idProduct}=="8328", TAG+="uaccess"
    # HTC Mass Storage Node
    SUBSYSTEM=="usb", ATTRS{idVendor}=="114d", ATTRS{idProduct}=="8200", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="114d", ATTRS{idProduct}=="8a12", TAG+="uaccess"


  '';

  services.xserver = {
    enable = true;
    layout = "us";

    # xset r rate 200 50
    autoRepeatDelay = 200;
    autoRepeatInterval = 50;

    xkbOptions = "terminate:ctrl_alt_bksp, ctrl:nocaps, keypad:hex, altwin:swap_alt_win, lv3:ralt_switch, compose:${composeKey}";

    wacom.enable = true;

    desktopManager = {
      default = "none";
      xterm.enable = false;
    };

    displayManager = {
      sessionCommands = "${userConfig}/bin/xinitrc";
      lightdm = {
        enable = true;
        background = "${pkgs.fetchurl {
          url = "https://jb55.com/img/haskell-space.jpg";
          sha256 = "e08d82e184f34e6a6596faa2932ea9699da9b9a4fbbd7356c344e9fb90473482";
        }}";
        greeters.gtk = {
          theme = theme;
          # iconTheme = icon-theme;
        };
      };
    };

    screenSection = ''
      Option "metamodes" "1920x1080_144 +0+0"
      Option "dpi" "96 x 96"
    '';

    windowManager = {
      xmonad = {
        enable = true;
        enableContribAndExtras = true;
      };
      default = "xmonad";
    };
  };

  # Enable the OpenSSH daemon.
  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [ pkgs.gutenprint ] ;
  };

  systemd.user.services.urxvtd = {
    enable = true;
    description = "RXVT-Unicode Daemon";
    wantedBy = [ "default.target" ];
    after    = [ "default.target" ];
    path = [ pkgs.rxvt_unicode-with-plugins ];
    serviceConfig = {
      Restart = "always";
      ExecStart = "${pkgs.rxvt_unicode-with-plugins}/bin/urxvtd -q -o";
    };
  };

  systemd.user.services.xautolock = {
    enable      = true;
    description = "X auto screen locker";
    wantedBy    = [ "graphical-session.target" ];
    after       = [ "graphical-session.target" ];
    serviceConfig.ExecStart = "${pkgs.xautolock}/bin/xautolock -time 10 -locker slock";
  };

  services.clipmenu.enable = true;

  environment.systemPackages = [pkgs.phonectl];
  systemd.user.services.phonectl = {
    enable      = true;
    description = "phonectl";
    wantedBy = [ "graphical-session.target" ];
    after    = [ "graphical-session.target" ];

    serviceConfig.ExecStart = "${pkgs.phonectl}/bin/phonectld";

    environment = with secrets.phonectl; {
      PHONECTLUSER=user;
      PHONECTLPASS=pass;
      PHONECTLPHONE=phone;
    };
  };

  # TODO: maybe doesn't have my package env
  systemd.user.services.xbindkeys = {
    enable      = true;
    description = "X key bind helper";
    wantedBy    = [ "graphical-session.target" ];
    after       = [ "graphical-session.target" ];
    serviceConfig.ExecStart = "${pkgs.xbindkeys}/bin/xbindkeys -n -f ${pkgs.jb55-dotfiles}/.xbindkeysrc";
  };

  # TODO: maybe doesn't have my package env
  systemd.user.services.twmnd = {
    enable      = true;

    description = "tiling window manager notifier";
    wantedBy    = [ "graphical-session.target" ];
    after       = [ "graphical-session.target" ];
    serviceConfig.ExecStart = "${pkgs.twmn}/bin/twmnd";
  };

  systemd.user.services.xinitrc = {
    enable      = true;
    description = "X session init commands";
    wantedBy    = [ "graphical-session.target" ];
    after       = [ "graphical-session.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${userConfig}/bin/xinitrc";
    };
  };

}
