# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.kernelPackages = pkgs.linuxPackages_3_17;
  boot.loader.gummiboot.enable = true;
  boot.loader.gummiboot.timeout = 5;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.cleanTmpDir = true;

  time.timeZone = "America/Vancouver";

  fonts.enableCoreFonts = true;

  hardware.bluetooth.enable = true;

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

  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    chromium
    wpa_supplicant_gui
    acpi
    powertop
    dmenu
    emacs
    compton
    redshift
    #hsetroot
    file
    gitFull
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
  ] ++ hsPackages;


  nixpkgs.config = {
    allowUnfree = true;
    chromium.enablePepperFlash = true;
    chromium.enablePepperPDF = true;

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

    desktopManager.default = "none";
    desktopManager.xterm.enable = false;

    displayManager = {
      desktopManagerHandlesLidAndPower = false;
      lightdm.enable = true;
      sessionCommands = ''
        ${pkgs.xlibs.xsetroot}/bin/xsetroot -cursor_name left_ptr
        ${pkgs.xlibs.xset}/bin/xset r rate 200 50
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
#   windowManager.xmonad.enable = true;
#   windowManager.xmonad.enableContribAndExtras = true;
#   windowManager.xmonad.extraPackages = haskellPackages: [
#     haskellPackages.taffybar
#   ];
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

  users.extraGroups.docker.members = [ "jb55" ];

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

