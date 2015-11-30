# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let caches = [ "https://cache.nixos.org/"];
    zsh = "/run/current-system/sw/bin/zsh";
    user = {
        name = "jb55";
        group = "users";
        uid = 1000;
        extraGroups = [ "wheel" ];
        createHome = true;
        home = "/home/jb55";
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
    hostName = "archer";
    extraHosts = ''
      174.143.211.135 freenode.znc.jb55.com
      174.143.211.135 globalgamers.znc.jb55.com
    '';
  };

  hardware = {
    bluetooth.enable = true;
    #pulseaudio.enable = true;
    opengl.driSupport32Bit = true;
  };

  environment.systemPackages = with pkgs; [
    bc
    chromium
    dmenu
    emacs
    dropbox-cli
    file
    gitAndTools.git-extras
    gitFull
    haskellPackages.xmobar
    hsetroot
    htop
    lsof
    nix-repl
    redshift
    rsync
    rxvt_unicode
    scrot
    silver-searcher
    zip
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
    xlibs.xset
    slock
    zathura
  ];

  nixpkgs.config = import ~/.nixpkgs/config.nix;

  services.redshift = {
    enable = true;
    temperature.day = 5700;
    temperature.night = 2800;
    # gamma=0.8

    latitude="49.270186";
    longitude="-123.109353";
  };

  services.syncthing = {
    enable = true;
    user = "jb55";
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
#       ${pkgs.xlibs.xsetroot}/bin/xsetroot -cursor_name left_ptr
        ${pkgs.xlibs.xset}/bin/xset r rate 200 50
        ${pkgs.xlibs.xset}/bin/xset m 0 0
        ${pkgs.haskellPackages.xmobar}/bin/xmobar &
        ${pkgs.hsetroot}/bin/hsetroot -solid '#1a2028'
        ${pkgs.xbindkeys}/bin/xbindkeys
        ${pkgs.feh}/bin/feh --bg-fill $HOME/etc/img/polygon1.png
        ${pkgs.xautolock}/bin/xautolock -time 5 -locker slock &
      '';

      lightdm.enable = true;
    };

    videoDrivers = [ "nvidia" ];

    screenSection = ''
      Option "metamodes" "1920x1080 +0+0"
    '';

    windowManager.spectrwm.enable = true;
    windowManager.default = "spectrwm";
#     enable = true;
#     enableContribAndExtras = true;
#     extraPackages = haskellngPackages: [
#       haskellngPackages.taffybar
#     ];
#   };
  };

  security.setuidPrograms = [ "slock" ];

  security.pki.certificates = [ flynnCert ];

  users.extraUsers.jb55 = user;

  users.defaultUserShell = zsh;
  users.mutableUsers = true;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  #virtualisation.docker.enable = true;

  programs.zsh.enable = true;
}

