# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let caches = [ "https://cache.nixos.org/"];
    nixfiles = "${home}/etc/nix-files";
    machineConfig = import "${nixfiles}/machines/${machine}.nix" pkgs;
    zsh = "/run/current-system/sw/bin/zsh";
    machine = "archer";
    nixpkgsConfig = import "${home}/.nixpkgs/config.nix";
    userConfig = (nixpkgsConfig {inherit pkgs;}).userConfig;
    home = "/home/jb55";
    user = {
        name = "jb55";
        group = "users";
        uid = 1000;
        extraGroups = [ "wheel" ];
        createHome = true;
        home = home;
        shell = zsh;
      };
    flynnProd = "-----BEGIN CERTIFICATE-----\nMIIDAzCCAe2gAwIBAgIQWmzx7lHQxRCWh1Nm8gse2zALBgkqhkiG9w0BAQswLTEO\nMAwGA1UEChMFRmx5bm4xGzAZBgNVBAsTEkZseW5uIEVwaGVtZXJhbCBDQTAeFw0x\nNjAxMTIwMDI0MjdaFw0yMTAxMTAwMDI0MjdaMC0xDjAMBgNVBAoTBUZseW5uMRsw\nGQYDVQQLExJGbHlubiBFcGhlbWVyYWwgQ0EwggEiMA0GCSqGSIb3DQEBAQUAA4IB\nDwAwggEKAoIBAQCn5f5K0iqK5ZtE2wjFnxD5hoMa3k9oyvkSflOO7tDyMi+zLyt3\nchvbccKcJLiYEWB5+RTu/JzmTNMejxh1toAglrrKTxqQ76t8oHDh0pD661rUELDQ\nI4a83Lh3A4JBY2IjFMSWHqSJjEK50HIUoPbkkIkRlBVpZP6n/c4Tgl43VTLiShFz\nRndX3PF3+Zxdilo4sIbFGKzw2Gq15qKuSV5P8FRpQMBC5uMAFaC2coxgdHZ0SclV\nm/te3f5L3Dg71dLXePqotlCBW89peoOBu3+n8v0IzMB0R4tMm5kT7kGVYWNN//Gf\nd4syJ7Q5mg2fWOdfOGiTOgZWw3OI/odn1TnPAgMBAAGjIzAhMA4GA1UdDwEB/wQE\nAwIABjAPBgNVHRMBAf8EBTADAQH/MAsGCSqGSIb3DQEBCwOCAQEAAfEDAS/VW7q0\nxaWqjtr341h+VKAjLPjgMrrOIli52oco1q5UvYWa5EVSoVtU2NZwzstDOIrnD/2T\n+RG1gOdMA+FyRIeC6qmQ7An4Tim2O08TG18jGRHDMzoIi2s4ZSek989OT4ZvLMmX\nyIh4M1mNt3v2aSOVEYiUrZ0yibo1i6QgRJSgIJ/QSCCyR1suyKIcQIlYGSgIeA0s\ncPUbGhjj2T28oAZDVDPx7QdXRwLz07FAvrblL4mm4LnI/tjZ9Zy5xYqRdEl/Q0uu\nPLmE19PrMCXE3r2kS3z+EY2KKbaZyaoP5nkSdx5YI1re6jPp6snZsjyCW7uOpY2Z\nVjkJuS7sCQ==\n-----END CERTIFICATE-----";
    flynnDev = "-----BEGIN CERTIFICATE-----\nMIIDAzCCAe2gAwIBAgIQRt44w0Dtmo6Kc0rZK/yGtzALBgkqhkiG9w0BAQswLTEO\nMAwGA1UEChMFRmx5bm4xGzAZBgNVBAsTEkZseW5uIEVwaGVtZXJhbCBDQTAeFw0x\nNjAxMTEyMzU4MTRaFw0yMTAxMDkyMzU4MTRaMC0xDjAMBgNVBAoTBUZseW5uMRsw\nGQYDVQQLExJGbHlubiBFcGhlbWVyYWwgQ0EwggEiMA0GCSqGSIb3DQEBAQUAA4IB\nDwAwggEKAoIBAQC1vDwqPoUmwRepdUV1rs67c/vnDn8GaFoKyLY4OBrmsxMA/E9J\nyeTK5cfTmFK7YnMjBOg93PxYkQIL3viJhL04gKqZdVF3VTMdP0RNYLIT28qyoWbt\nbDfc/OMLDh8pNXtOovCuIIWkKkVJWPk+SA5a1Cj6755WU8faRJ58unUFK3AeurFs\n5g7F+FZahzrGqYAZt6uN/er3OQlYWOueklMBkQBo26EPN9GX6wSJJyh+tlXXnIU7\naGs+Y3za8Sf9aitEdZJ1++S7nunzfv6DHmT+qGLgKkeykWJp3pt01l2KfM99n4cu\ndTMY1sdI8xjc5bKb1N80xf39GZfCw5btzZctAgMBAAGjIzAhMA4GA1UdDwEB/wQE\nAwIABjAPBgNVHRMBAf8EBTADAQH/MAsGCSqGSIb3DQEBCwOCAQEAOy5O7cME57bR\nBemhUY9tQrcxJOIu/Wzo6ccHxDzWMJ2aCPuFZGcCvflGKdYorVFDGq4qWAAISrRT\n3j5gtfPgDxGlck17RdptM1PB6IM//1WwoZoKO6h6tRyXGjCQr7PvhBB9rWepZfyZ\n8CxH6XZY3To0IdVfikXnSgWpFncpmlfl465fBERKkDRN0+5q51wlxPNsykQOzgjo\ngiJySbYUD345vGDsVwAffwMnnE9xwGB9Xdoyd7AvAaXFmsYONGCb0+kaN4CZQYtR\nP1zau8J1jy5KAahfvMIWvih2aWqeqQpNQ9PfSsz5F2C76XvkxnkOicga9tuoJYgo\nluF0apj1Qg==\n-----END CERTIFICATE-----";
in {
imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot = {
    loader.grub = {
      enable = true;
      version = 2;
      device = "/dev/sda";
    };

    supportedFilesystems = ["ntfs"];
  };

  programs.ssh.startAgent = false;

  time.timeZone = "America/Vancouver";

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    enableCoreFonts = true;
    fonts = with pkgs; [
      corefonts
      inconsolata
      ubuntu_font_family
      fira-code
      fira-mono
      source-code-pro
      ipafont
      noto-fonts-emoji
    ];
  };

  nix = {
    binaryCaches = caches;
    trustedBinaryCaches = caches;
    binaryCachePublicKeys = [
      "hydra.cryp.to-1:8g6Hxvnp/O//5Q1bjjMTd5RO8ztTsG8DKPOAg9ANr2g="
    ];
  };

  networking = {
    hostName = machine;
    extraHosts = ''
      174.143.211.135 freenode.znc.jb55.com
      6.6.6.187 archer
    '';

    firewall = {
      allowPing = true;
      allowedTCPPorts = [ 22 5000 143 ];
    };
  };

  hardware = {
    bluetooth.enable = true;
    pulseaudio = {
      package = pkgs.pulseaudioFull;
      enable = true;
      support32Bit = true;
    };
    sane = {
      enable = true;
      configDir = "${home}/.sane";
    };
    opengl.driSupport32Bit = true;
  };

  environment.x11Packages = with pkgs; [
    gtk
  ];

  environment.variables = {
    # GTK2_RC_FILES = "${pkgs.numix-gtk-theme}/share/themes/Numix/gtk-2.0/gtkrc";
    GTK_DATA_PREFIX = "${config.system.path}";
  };

  environment.systemPackages = with pkgs; [
    gnome.gnome_icon_theme
    gtk-engine-murrine
    hicolor_icon_theme
    numix-gtk-theme
    numix-icon-theme-circle
    paper-gtk-theme
    shared_mime_info
    xfce.thunar
    xfce.xfce4icontheme  # for thunar

    bc
    pidgin
    binutils
    chromium
    dmenu
    dropbox-cli
    emacs
    file
    gitAndTools.git-extras
    gitFull
    haskellPackages.taffybar
    hsetroot
    htop
    lsof
    mpc_cli
    nix-repl
    parcellite
    patchelf
    redshift
    rsync
    rxvt_unicode
    scrot
    silver-searcher
    slock
    spotify
    subversion
    unzip
    vim
    vlc
    wget
    xautolock
    xbindkeys
    xclip
    xdg_utils
    xlibs.xev
    xlibs.xmodmap
    xlibs.xset
    zathura
    zip
  ];

  # systemd.services.emacs = {
  #   description = "Emacs Daemon";
  #   environment = {
  #     GTK_DATA_PREFIX = config.system.path;
  #     SSH_AUTH_SOCK = "%t/ssh-agent";
  #     GTK_PATH = "${config.system.path}/lib/gtk-3.0:${config.system.path}/lib/gtk-2.0";
  #     NIX_PROFILES = "${pkgs.lib.concatStringsSep " " config.environment.profiles}";
  #     TERMINFO_DIRS = "/run/current-system/sw/share/terminfo";
  #     ASPELL_CONF = "dict-dir /run/current-system/sw/lib/aspell";
  #   };
  #   serviceConfig = {
  #     Type = "forking";
  #     ExecStart = "${pkgs.emacs}/bin/emacs --daemon";
  #     ExecStop = "${pkgs.emacs}/bin/emacsclient --eval (kill-emacs)";
  #     Restart = "always";
  #   };
  #   wantedBy = [ "default.target" ];
  # };
  # systemd.services.emacs.enable = true;

  nixpkgs.config = nixpkgsConfig;

  services.redshift = {
    enable = true;
    temperature.day = 5700;
    temperature.night = 2800;
    # gamma=0.8

    latitude="49.270186";
    longitude="-123.109353";
  };

  services.zerotierone.enable = true;
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

  services.mongodb.enable = true;
  services.redis.enable = true;

  services.postgresql = {
    enable = true;
    authentication = "local all all ident";
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
      sessionCommands = "${userConfig}/bin/xinitrc";
      lightdm.enable = true;
    };

    videoDrivers = [ "nvidia" ];

    screenSection = ''
      Option "metamodes" "1920x1080 +0+0"
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

  virtualisation.virtualbox.host.enable = true;
  virtualisation.docker.enable = true;

  security.setuidPrograms = [ "slock" ];
  security.pki.certificates = [ flynnDev flynnProd ];

  users.extraUsers.jb55 = user;
  users.extraGroups.vboxusers.members = [ "jb55" ];
  users.extraGroups.docker.members = [ "jb55" ];

  users.defaultUserShell = zsh;
  users.mutableUsers = true;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
  };

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [ pkgs.gutenprint ] ;
  };

  programs.zsh.enable = true;
}
