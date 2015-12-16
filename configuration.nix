# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let caches = [ "https://cache.nixos.org/"];
    zsh = "/run/current-system/sw/bin/zsh";
    machine = "archer";
    home = "/home/jb55";
    machineConfig = import "${home}/etc/nix-files/machines/${machine}.nix";
    user = {
        name = "jb55";
        group = "users";
        uid = 1000;
        extraGroups = [ "wheel" ];
        createHome = true;
        home = home;
        shell = zsh;
      };
    flynnCert = "-----BEGIN CERTIFICATE-----\nMIIDBDCCAe6gAwIBAgIRAPEpcMuL9MBoJy4I2TJBwSkwCwYJKoZIhvcNAQELMC0x\nDjAMBgNVBAoTBUZseW5uMRswGQYDVQQLExJGbHlubiBFcGhlbWVyYWwgQ0EwHhcN\nMTUxMTE3MjEzMjM5WhcNMjAxMTE1MjEzMjM5WjAtMQ4wDAYDVQQKEwVGbHlubjEb\nMBkGA1UECxMSRmx5bm4gRXBoZW1lcmFsIENBMIIBIjANBgkqhkiG9w0BAQEFAAOC\nAQ8AMIIBCgKCAQEA4KzIAMp0Itlzilc4qpZJyPI9V1h+D91HJGmGZ4dlbMnU/cr5\nFV32eymw4vT6DxYo4+5LkXQ6FbRQ5fVKvNGwUYC71V0ir7yQc6w8mPYSo2LOCWIB\nk9uC66ERMgiQ0Jaii30ptq9dYJRvwoT7ApgUwOYvvYmD+Xc9x2WQQiThecGEJl4l\nZIO0YuBaqohsBuVByxUuhkpu7A0Kv4qRO3I9rWmRgAzpeTvMaiN+TjaukPjzrxIu\ncRopysKS19yVL1mBnfrPAZIKdiW4KfYH7GnV0dSwUsFH36iO30Tb+WWo3302XDZi\nKDBy8YweYkkj8kQZ6L6R5zgej5bVsE3Pf+BzywIDAQABoyMwITAOBgNVHQ8BAf8E\nBAMCAAYwDwYDVR0TAQH/BAUwAwEB/zALBgkqhkiG9w0BAQsDggEBACdxeKbSpyYG\nIO8SoknVG+l4rDgnLh9p12frRicBfNey7NEn9tJGAZ9tMt9xq/VEksK8GS3reehi\nCzo5Q4vFusgxfBCTglmAmJinZI7PbMTuc2qKcCkHKnBMrKeFENOVPBO90XOAQ5To\nwyy+1NKtxpgEV9FfFxxR5VNCxaOgF7Y8u1YhG0biWKRKcjGcJq9HiASsWeD5m6+S\n+QSk0J/SaIobX/d90IGR54bnubObbspDCGi76FiKxWDOSU0Wi1yNcIbFbdqeSXHV\n5ky3QEopqf4S9D4OLkdauxO6M8cKoSpeDAYLLiViBpLb8WZAafse26Vm34w521pU\nuw2W4U8T+IU=\n-----END CERTIFICATE-----";
in {
imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
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
    '';
    firewall = {
      allowPing = true;
      allowedTCPPorts = [ 8999 5000 ];
    };
  };

  hardware = {
    bluetooth.enable = true;
    pulseaudio.enable = false;
    sane = {
      enable = true;
      configDir = "${home}/.sane";
    };
    opengl.driSupport32Bit = true;
  };

  environment.x11Packages = with pkgs; [
    gnome.gnomeicontheme
    gtk
    hicolor_icon_theme
    shared_mime_info
    xfce.thunar
    xfce.xfce4icontheme  # for thunar
  ];

  environment.systemPackages = with pkgs; [
    bc
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
    nix-repl
    parcellite
    patchelf
    redshift
    rsync
    rxvt_unicode
    scrot
    silver-searcher
    slock
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

  nixpkgs.config = import "${home}/.nixpkgs/config.nix";

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
  };

  services.mongodb = {
    enable = true;
  };

  services.postgresql = {
    enable = true;
    authentication = "local all all ident";
  };

  services.xserver = {
    enable = true;
    layout = "us";
    xkbOptions = "terminate:ctrl_alt_bksp, ctrl:nocaps";

    startGnuPGAgent = true;

    desktopManager = {
      default = "none";
      xterm.enable = false;
    };

    displayManager = {
      sessionCommands = ''
        ${pkgs.feh}/bin/feh --bg-fill $HOME/etc/img/polygon1.png
        ${pkgs.haskellPackages.taffybar}/bin/taffybar &
        ${pkgs.parcellite}/bin/parcellite &
        ${pkgs.xautolock}/bin/xautolock -time 5 -locker slock &
        ${pkgs.xbindkeys}/bin/xbindkeys
        ${pkgs.xlibs.xmodmap}/bin/xmodmap $HOME/.Xmodmaor
        ${pkgs.xlibs.xset}/bin/xset r rate 200 50
      '' + "\n" + (machineConfig pkgs).sessionCommands or "";

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
  security.pki.certificates = [ flynnCert ];

  users.extraUsers.jb55 = user;
  users.extraGroups.vboxusers.members = [ "jb55" ];

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

  #virtualisation.docker.enable = true;

  programs.zsh.enable = true;
}
