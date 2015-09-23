# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let caches = [ "https://cache.nixos.org/"
               "http://hydra.cryp.to"
             ];
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

  programs.ssh.startAgent = true;

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
    ];
  };

  nix = {
    binaryCaches = caches;
    trustedBinaryCaches = caches;
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
    zathura
    bc
    chromium
    compton
    dmenu
    emacs
    file
    gitAndTools.git-extras
    haskellPackages.xmobar
    gitFull
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
    steam
    subversion
    unzip
    vim
    vlc
    wget
    xbindkeys
    xclip
    xdg_utils
    xlibs.xev
    xlibs.xset
    slock
  ];

  nixpkgs.config = {
    allowUnfree = true;
    chromium.enablePepperFlash = true;
    chromium.enablePepperPDF = true;
  };

  services.redshift = {
    enable = true;
    temperature.day = 5700;
    temperature.night = 3000;
    # gamma=0.8

    latitude="49.270186";
    longitude="-123.109353";
  };

  services.mongodb = {
    enable = true;
  };

  services.xserver = {
    enable = true;
    layout = "us";
    xkbOptions = "terminate:ctrl_alt_bksp, ctrl:nocaps";

    desktopManager = {
      default = "none";
      xterm.enable = false;
    };

    displayManager = {
      sessionCommands = ''
#       ${pkgs.xlibs.xsetroot}/bin/xsetroot -cursor_name left_ptr
        ${pkgs.xlibs.xset}/bin/xset r rate 200 50
        ${pkgs.haskellPackages.xmobar}/bin/xmobar &
        ${pkgs.xlibs.xinput}/bin/xinput set-prop 8 "Device Accel Constant Deceleration" 3
        ${pkgs.compton}/bin/compton -r 4 -o 0.75 -l -6 -t -6 -c -G -b
        ${pkgs.hsetroot}/bin/hsetroot -solid '#1a2028'
        ${pkgs.xbindkeys}/bin/xbindkeys
        ${pkgs.feh}/bin/feh --bg-fill $HOME/etc/img/polygon1.png
      '';

      lightdm.enable = true;
    };

    videoDrivers = [ "nvidia" ];

    screenSection = ''
      Option "metamodes" "2048x1152_60 +0+0"
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

