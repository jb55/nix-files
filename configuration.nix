# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda";

  programs.ssh.startAgent = false; # gpg agent takes over this role

  time.timeZone = "America/Vancouver";

  fonts.enableCoreFonts = true;

  networking = {
    hostName = "archer";
    extraHosts = ''
      174.143.211.135 freenode.znc.jb55.com
      174.143.211.135 globalgamers.znc.jb55.com
    '';
  };

  hardware = {
    bluetooth.enable = true;
    pulseaudio.enable = true;
    opengl.driSupport32Bit = true;
  };

  environment.systemPackages = with pkgs; [
    apvlv
    bc
    chromium
    compton
    dmenu
    emacs
    file
    gitAndTools.git-extras
    gitFull
    haskellPackages.ShellCheck
    haskellPackages.cabal-install
#   haskellPackages.cabal2nix
    haskellPackages.ghc
    haskellPackages.hlint
    hsetroot
    htop
    ipafont
    lsof
    nix-repl
    notmuch
    popcorntime
    redshift
    rsync
    rxvt_unicode
    scrot
    silver-searcher
    steam
    subversion
    unzip
    vim
    vlc
    wget
    xclip
    xdg_utils
    xlibs.xev
    xlibs.xset
  ];

  nixpkgs.config = {
    allowUnfree = true;
    chromium.enablePepperFlash = true;
    chromium.enablePepperPDF = true;
  };

  services.xserver = {
    enable = true;
    layout = "us";
    xkbOptions = "terminate:ctrl_alt_bksp, ctrl:nocaps";

    desktopManager = {
      default = "none";
      xterm.enable = true;
    };

    displayManager = {
      sessionCommands = ''
#       ${pkgs.xlibs.xsetroot}/bin/xsetroot -cursor_name left_ptr
        ${pkgs.xlibs.xset}/bin/xset r rate 200 50
        ${pkgs.xlibs.xinput}/bin/xinput set-prop 8 "Device Accel Constant Deceleration" 3
        ${pkgs.redshift}/bin/redshift &
        ${pkgs.compton}/bin/compton -r 4 -o 0.75 -l -6 -t -6 -c -G -b
        ${pkgs.hsetroot}/bin/hsetroot -solid '#1a2028'
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

  users.extraUsers.jb55 = {
    name = "jb55";
    group = "users";
    uid = 1000;
    extraGroups = [ "wheel" ];
    createHome = true;
    home = "/home/jb55";
    shell = "/run/current-system/sw/bin/zsh";
  };

  users.mutableUsers = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  virtualisation.docker.enable = true;

  programs.zsh.enable = true;
}

