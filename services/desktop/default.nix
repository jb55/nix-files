{ util, userConfig, theme, icon-theme }:
{ config, lib, pkgs, ... }:
let
  clippings-pl-file = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/jb55/kindle-clippings/master/clippings.pl";
    sha256 = "13bn5lvm4p85369yj88jr62h3zalmmyrzmjc332qwlqgqhyf3dls";
  };
  clippings-pl = util.writeBash "clippings.pl" ''
    ${lib.getBin pkgs.perl}/bin/perl ${clippings-pl-file}
  '';
in
{
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
    temperature.night = 3700;
    # gamma=0.8

    brightness = {
      day = "1.0";
      night = "0.5";
    };

    latitude="49.270186";
    longitude="-123.109353";
  };

  services.autofs = {
   enable = true;
    autoMaster =
      let
        mapConf = pkgs.writeText "auto" ''
          kindle    -fstype=vfat,gid=100,noatime,rw,umask=002,user,utf8         :/dev/kindle
        '';
      in ''
        /media file:${mapConf}
      '';
  };

  systemd.services.kindle-sync = {
    enable = true;
    description = "sync kindle";
    after    = [ "media-kindle.mount" ];
    requires = [ "media-kindle.mount" ];
    wantedBy = [ "media-kindle.mount" ];
    serviceConfig = {
      ExecStart = util.writeBash "kindle-sync" ''
        export PATH=${lib.makeBinPath (with pkgs; [ coreutils eject perl dos2unix git ])}:$PATH
        cp /media/kindle/documents/My\ Clippings.txt /tmp/clippings.txt

        </tmp/clippings.txt dos2unix | ${clippings-pl} > /tmp/clippings.yml
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

  services.udev.extraRules = ''
    # yubikey neo
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1050", ATTRS{idProduct}=="0116", MODE="0666"

    # yubikey4
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1050", ATTRS{idProduct}=="0407", MODE="0666"

    # kindle
    ATTRS{idVendor}=="1949", ATTRS{idProduct}=="0004", SYMLINK+="kindle"

  '';

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

    videoDrivers = [ "nvidia" ];

    screenSection = ''
      Option "metamodes" "1920x1080_144 +0+0 { ForceCompositionPipeline = On }"
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

  systemd.user.services.urxvtd = {
    enable = true;
    description = "RXVT-Unicode Daemon";
    wantedBy = [ "default.target" ];
    path = [ pkgs.rxvt_unicode-with-plugins ];
    serviceConfig = {
      Restart = "always";
      ExecStart = "${pkgs.rxvt_unicode-with-plugins}/bin/urxvtd -q -o";
    };
  };

}
