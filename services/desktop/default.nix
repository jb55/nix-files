theme:
{ config, lib, pkgs, ... }:
let bgimg = pkgs.fetchurl {
      url = "http://jb55.com/img/haskell-space.jpg";
      md5 = "04d86f9b50e42d46d566bded9a91ee2c";
    };
    displayEnv = {
      DISPLAY = ":0";
      # XAUTHORITY = "/home/jb55/.Xauthority";
    };
    defaultEnvironment = theme.environment // displayEnv;
in {
  # sync ical to org
  systemd.services.sync-ical2org.enable = true;
  services.hoogle = {
    enable = true;
    packages = pkgs.myHaskellPackages;
    haskellPackages = pkgs.haskellPackages;
  };

  services.redshift = {
    enable = true;
    temperature.day = 5700;
    temperature.night = 2800;
    # gamma=0.8

    latitude="49.270186";
    longitude="-123.109353";
  };

  services.mpd = {
    enable = true;
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

  services.xserver = {
    enable = true;
    layout = "us";

    xkbOptions = "terminate:ctrl_alt_bksp, ctrl:nocaps, keypad:hex, altwin:swap_alt_win, lv3:ralt_switch, compose:rwin";

    wacom.enable = true;

    desktopManager = {
      default = "none";
      xterm.enable = false;
    };

    displayManager = {
      lightdm = {
        enable = true;
        background = "${pkgs.fetchurl {
          url = "https://jb55.com/img/haskell-space.jpg";
          md5 = "04d86f9b50e42d46d566bded9a91ee2c";
        }}";
        greeters.gtk = {
          theme.name = theme.name;
          theme.package = theme.package;
          # iconTheme = icon-theme;
        };
      };
    };

    config = ''
      Section "InputClass"
        Identifier "Razer Razer DeathAdder 2013"
        MatchIsPointer "yes"
        Option "AccelerationProfile" "-1"
        Option "ConstantDeceleration" "5"
        Option "AccelerationScheme" "none"
        Option "AccelSpeed" "-1"
      EndSection
    '';

    videoDrivers = [ "nvidia" ];

    screenSection = ''
      Option "metamodes" "1920x1080 +0+0"
      Option "dpi" "96 x 96"
    '';

    windowManager = {
      xmonad = {
        enable = true;
        enableContribAndExtras = true;
        extraPackages = hp: [
          hp.taffybar
        ];
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

  systemd.user.services.taffybar = {
    enable      = true;
    environment = defaultEnvironment;
    path        = theme.packages;
    description = "Taffybar status bar";
    wantedBy    = [ "default.target" ];
    serviceConfig = {
      Restart = "always";
      RestartSec = 3;
      ExecStart = pkgs.writeScript "taffybar-wrapper" ''
#! ${pkgs.bash}/bin/bash
        set -e
        export $(grep ^DBUS_SESSION_BUS_ADDRESS $HOME/.dbus/session-bus/*-0)
        export PATH=${pkgs.iproute}/bin:"$PATH"

        "${pkgs.haskellPackages.ghcWithPackages (pkgs: with pkgs; [ taffybar ])}"/bin/taffybar
      '';
    };
  };

  systemd.user.services.volumeicon = {
    enable      = true;
    environment = defaultEnvironment;
    path        = theme.packages;
    description = "Volume icon for status bar";
    wantedBy    = [ "default.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.volumeicon}/bin/volumeicon";
      Restart = "always";
      RestartSec = 3;
    };
  };

  systemd.user.services.xautolock = {
    enable      = false;
    description = "X auto screen locker";
    wantedBy    = [ "default.target" ];
    serviceConfig = {
      Restart = "always";
      RestartSec = 3;
      ExecStart = "${pkgs.xautolock}/bin/xautolock -time 10 -locker slock";
    };
  };

  systemd.user.services.clipit = {
    enable      = true;
    environment = defaultEnvironment;
    path        = theme.packages;
    description = "ClipIt clipboard manager";
    wantedBy    = [ "default.target" ];
    serviceConfig = {
      Restart = "always";
      RestartSec = 3;
      ExecStart = "${pkgs.clipit}/bin/clipit";
    };
  };

  systemd.user.services.xbindkeys = {
    enable      = true;
    environment = displayEnv;
    description = "X key bind helper";
    wantedBy    = [ "default.target" ];
    serviceConfig = {
      Restart = "always";
      RestartSec = 3;
      ExecStart = "${pkgs.xbindkeys}/bin/xbindkeys -n -f ${pkgs.jb55-dotfiles}/.xbindkeysrc";
    };
  };

  systemd.user.services.xinitrc = {
    enable      = true;
    environment = displayEnv;
    description = "X session init commands";
    wantedBy    = [ "taffybar.service" ];
    partOf      = [ "display-manager.service" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeScript "xinitrc" ''
#!${pkgs.bash}/bin/bash
        ${pkgs.feh}/bin/feh --bg-fill ${bgimg}
        ${pkgs.xlibs.xsetroot}/bin/xsetroot -cursor_name left_ptr
        ${pkgs.xlibs.xmodmap}/bin/xmodmap ${pkgs.jb55-dotfiles}/.Xmodmap
        ${pkgs.xlibs.xset}/bin/xset r rate 200 50
      '';
    };
  };

  systemd.user.services.urxvtd = {
    enable = true;
    description = "RXVT-Unicode Daemon";
    wantedBy = [ "default.target" ];
    path = [ pkgs.rxvt_unicode-with-plugins ];
    serviceConfig = {
      Restart = "always";
      RestartSec = 3;
      ExecStart = "${pkgs.rxvt_unicode-with-plugins}/bin/urxvtd -q -o";
    };
  };

}
