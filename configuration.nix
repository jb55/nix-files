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

  services.xserver.startGnuPgAgent = true;
  programs.ssh.startAgent = false; # gpg agent takes over this role

  time.timeZone = "America/Vancouver";

  fonts.enableCoreFonts = true;

  networking.hostName = "monad"; # Define your hostname.
  networking.hostId = "900eef22";
  # networking.wireless.enable = true;  # Enables wireless.
  hardware.bluetooth.enable = true;

  environment.systemPackages = with pkgs; [
    chromium
    dmenu
    ipafont                            # japanese fonts
    emacs
    compton
    notmuch
    mbsync
    redshift
    hsetroot
    file
    gitFull
    haskellngPackages.cabal2nix
    haskellngPackages.cabal-install
    haskellngPackages.ghc
    haskellngPackages.hlint
    htop
    nix-repl
    rxvt_unicode
    scrot
    silver-searcher
    vim
    wget
    unzip
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

    desktopManager.default = "none";
    desktopManager.xterm.enable = true;

    displayManager = {
      sessionCommands = ''
#       ${pkgs.xlibs.xsetroot}/bin/xsetroot -cursor_name left_ptr
        ${pkgs.xlibs.xset}/bin/xset r rate 200 50
        ${pkgs.xlibs.xinput}/bin/xinput set-prop 8 "Device Accel Constant Deceleration" 3
        ${pkgs.redshift}/bin/redshift &
        ${pkgs.compton}/bin/compton -r 4 -o 0.75 -l -6 -t -6 -c -G -b
        ${pkgs.hsetroot}/bin/hsetroot -solid '#1a2028'
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

  hardware.opengl.driSupport32Bit = true;

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
  services.openssh.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable the X11 windowing system.
  # services.xserver.xkbOptions = "eurosign:e";

  virtualisation.docker.enable = true;

  programs.zsh.enable = true;
  programs.zsh.interactiveShellInit =
    ''
      # Taken from <nixos/modules/programs/bash/command-not-found.nix>
      # and adapted to zsh (i.e. changed name from 'handle' to
      # 'handler').

      # This function is called whenever a command is not found.
      command_not_found_handler() {
        local p=/run/current-system/sw/bin/command-not-found
        if [ -x $p -a -f /nix/var/nix/profiles/per-user/root/channels/nixos/programs.sqlite ]; then
          # Run the helper program.
          $p "$1"
          # Retry the command if we just installed it.
          if [ $? = 126 ]; then
            "$@"
          else
            return 127
          fi
        else
          echo "$1: command not found" >&2
          return 127
        fi
      }
    '';
}

