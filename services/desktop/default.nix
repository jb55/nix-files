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

  services.hoogle = {
    enable = false;
    packages = pkgs.myHaskellPackages;
    haskellPackages = pkgs.haskellPackages;
  };

  services.gnome3.gnome-keyring.enable = true;

  services.trezord.enable = true;

  programs.gnupg.trezor-agent = {
    enable = true;
    configPath = "/home/jb55/.gnupg";
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
  };

  location.latitude = 49.270186;
  location.longitude = -123.109353;

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

  services.udev.extraRules = ''


  '';

  hardware.opengl.enable = true;

  services.xserver = {
    enable = true;
    layout = "us";

    # xset r rate 200 50
    autoRepeatDelay = 200;
    autoRepeatInterval = 50;

    xkbOptions = "terminate:ctrl_alt_bksp, ctrl:nocaps, keypad:hex, altwin:swap_alt_win, lv3:ralt_switch, compose:${composeKey}";

    wacom.enable = false;

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
    wantedBy = [ "graphical-session.target" ];
    after    = [ "graphical-session.target" ];
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
  # systemd.user.services.xbindkeys = {
  #   enable      = true;
  #   description = "X key bind helper";
  #   wantedBy    = [ "graphical-session.target" ];
  #   after       = [ "graphical-session.target" ];
  #   serviceConfig.ExecStart = "${pkgs.xbindkeys}/bin/xbindkeys -n -f ${pkgs.jb55-dotfiles}/.xbindkeysrc";
  # };

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
