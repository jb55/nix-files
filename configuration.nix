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
    hostName = "monad";
    hostId = "900eef22";
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
    haskellPackages.cabal2nix
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

 #services.btsync = {
 #  # disable for now until I fix this
 #  enable = false;
 #  deviceName = "monad";
 #  httpListenPort = 9902;
 #  storagePath = "/home/jb55/btsync";
 #  sharedFolders = [{
 #    secret         = "AFNEZRTN4VI2MKMSWKINZDHSGLOMVQJQU";
 #    directory      = "/home/jb55/src";
 #    useRelayServer = true;
 #    useTracker     = true;
 #    useDHT         = false;
 #    searchLAN      = true;
 #    useSyncTrash   = true;
 #  }];
 #};
  services.redshift = {
    enable = true;
    temperature.day = 5700;
    temperature.night = 3200;
    # gamma=0.8

    latitude="49.270186";
    longitude="-123.109353";
  }

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
        ${pkgs.compton}/bin/compton -r 4 -o 0.75 -l -6 -t -6 -c -G -b
        ${pkgs.hsetroot}/bin/hsetroot -solid '#1a2028'
        ${pkgs.feh}/bin/feh --bg-fill $HOME/etc/img/polygon1.png
      '';

      lightdm.enable = true;
    };

    videoDrivers = [ "nvidia" ];

    screenSection = ''
      Option "metamodes" "1920x1080_144 +0+0"
    '';

    windowManager.default = "spectrwm";
    windowManager.spectrwm.enable = true;
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

  # bittorrent web ui
 #services.transmission = {
 #  enable = false;
 #  settings = {
 #    download-dir = "/home/jb55/torrents";
 #    incomplete-dir-enabled = false;
 #    rpc-whitelist = "127.0.0.1,192.168.*.*";
 #  };
 #};

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable the X11 windowing system.
  # services.xserver.xkbOptions = "eurosign:e";

  virtualisation.docker.enable = true;

  programs.zsh.enable = true;
 #programs.zsh.interactiveShellInit =
 #  ''
 #    # Taken from <nixos/modules/programs/bash/command-not-found.nix>
 #    # and adapted to zsh (i.e. changed name from 'handle' to
 #    # 'handler').

 #    # This function is called whenever a command is not found.
 #    command_not_found_handler() {
 #      local p=/run/current-system/sw/bin/command-not-found
 #      if [ -x $p -a -f /nix/var/nix/profiles/per-user/root/channels/nixos/programs.sqlite ]; then
 #        # Run the helper program.
 #        $p "$1"
 #        # Retry the command if we just installed it.
 #        if [ $? = 126 ]; then
 #          "$@"
 #        else
 #          return 127
 #        fi
 #      else
 #        echo "$1: command not found" >&2
 #        return 127
 #      fi
 #    }
 #  '';
}

