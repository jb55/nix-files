userConfig:
{ config, lib, pkgs, ... }:
{
  # sync ical to org
  systemd.services.sync-ical2org.enable = true;
  services.hoogle = {
    enable = true;
    packages = pkgs.myHaskellPackages;
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
    xkbOptions = "terminate:ctrl_alt_bksp, ctrl:nocaps";

    startGnuPGAgent = true;
    wacom.enable = true;


    desktopManager = {
      default = "none";
      xterm.enable = false;
    };

    displayManager = {
      slim = {
        defaultUser = "jb55";
        theme = pkgs.fetchFromGitHub {
          owner = "crough";
          repo = "nixos-slim-theme";
          rev = "9c37840ba8b42d8f488eb80074ea940af9536360";
          sha256 = "1mvys3jq4sh7dmdzsnf01cl20bagrvh2jc23fgjiyrgdjwqv7d18";
        };
      };
      sessionCommands = "${userConfig}/bin/xinitrc";
    };

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
