# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  #boot.kernelPackages = pkgs.linuxPackages_3_17;
  #boot.kernelModules = [ "applesmc" ];
  boot.loader.gummiboot.enable = true;
  boot.loader.gummiboot.timeout = 5;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.cleanTmpDir = true;

  programs.ssh.startAgent = true;

  time.timeZone = "America/Vancouver";

  fonts.enableCoreFonts = true;

  networking = {
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

  # networking
  networking.hostName = "arrow-nixos";
  networking.wireless.enable = true;

  # Should I use this instead? Both are currently broken.
  # networking.networkmanager.enable = true;
  # networking.connman.enable = true;

  # Sadly wicd worked less than wpa_supplicant
  # networking.interfaceMonitor.enable = false;
  # networking.useDHCP = false;
  # networking.wicd.enable = true;

  # programs
  programs.ssh.agentTimeout = "12h";
  programs.zsh.enable = true;
  programs.light.enable = true;

  # services
  services.nixosManual.showManual = true;
  services.openssh.enable = true;
  services.upower.enable = true;
  services.printing.enable = true;

  #virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    #chromium
    #firefox
    #hsetroot
    acpi
    compton
    dmenu
    emacs
    file
    gitFull
    gitAndTools.git-extras
    htop
    ipafont                            # japanese fonts
    mbsync
    nix-repl
    notmuch
    powertop
    redshift
    rxvt_unicode
    scrot
    silver-searcher
    unzip
    vim
    wget
    xlibs.xev xdg_utils
    xlibs.xset
  ];

  nix = {
    trustedBinaryCaches = ["http://localhost:8080/"];
  };

  nixpkgs.config = {
    allowUnfree = true;

    chromium = {
      enablePepperFlash = true;
      enablePepperPDF = true;
      hiDPISupport = true;
    };

    firefox = {
      enableGoogleTalkPlugin = true;
      enableAdobeFlash = true;
    };

    packageOverrides = pkgs: {
      #jre = pkgs.oraclejre8;
      #jdk = pkgs.oraclejdk8;
      linux_3_17 = pkgs.linux_3_17.override {
        extraConfig =
        ''
          THUNDERBOLT m
        '';
      };
    };
  };

  services.xserver = {
    enable = true;

    vaapiDrivers = [ pkgs.vaapiIntel ];
    startGnuPgAgent = false;

    desktopManager = {
      default = "none";
      xterm.enable = false;
    };

    displayManager = {
      desktopManagerHandlesLidAndPower = false;
      lightdm.enable = true;
      sessionCommands = ''
        #${pkgs.redshift}/bin/redshift &
        #${pkgs.compton}/bin/compton -r 4 -o 0.75 -l -6 -t -6 -c -G -b
        ${pkgs.xlibs.xsetroot}/bin/xsetroot -cursor_name left_ptr
        ${pkgs.xlibs.xset}/bin/xset r rate 200 50
        ${pkgs.feh}/bin/feh --bg-fill $HOME/etc/img/polygon1.png
      '';
    };

    # TODO: Use the mtrack driver but do better than this.
    # multitouch.enable = true;
    # multitouch.invertScroll = true;

    synaptics.additionalOptions = ''
      Option "VertScrollDelta" "-111"
      Option "HorizScrollDelta" "-111"
    '';
    synaptics.buttonsMap = [ 1 3 2 ];
    synaptics.enable = true;
    synaptics.tapButtons = true;
    synaptics.fingersMap = [ 0 0 0 ];
    synaptics.twoFingerScroll = true;
    synaptics.vertEdgeScroll = false;

    videoDrivers = [ "nvidia" ];

    screenSection = ''
      Option "DPI" "96 x 96"
      Option "NoLogo" "TRUE"
      Option "nvidiaXineramaInfoOrder" "DFP-2"
      Option "metamodes" "DP-0: nvidia-auto-select +2880+1152 {rotation=right}, HDMI-0: nvidia-auto-select +416+0, DP-2: nvidia-auto-select +0+1152"
    '';

    xkbOptions = "terminate:ctrl_alt_bksp, ctrl:nocaps";

    windowManager.default = "spectrwm";
    windowManager.spectrwm.enable = true;
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

  programs.zsh.enable = true;
}

