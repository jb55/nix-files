# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let caches = [ "https://cache.nixos.org/"];
    machine = "archer";
    machinePath = p: let m = "/" + machine;
                     in ./machines + m + p;
    machineConfig = import (machinePath "") pkgs;
    userConfig = pkgs.callPackage ./nixpkgs/dotfiles.nix {
      machineSessionCommands = machineConfig.sessionCommands or "";
    };
    zsh = "${pkgs.zsh}/bin/zsh";
    nixpkgsConfig = import ./nixpkgs/config.nix;
    home = "/home/jb55";
    private = import ./private.nix;
    user = {
        name = "jb55";
        group = "users";
        uid = 1000;
        extraGroups = [ "wheel" ];
        createHome = true;
        home = home;
        shell = zsh;
      };
in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./certs
      ./fonts
      ./services/hoogle
      (machinePath "/networking")
      (import ./timers/sync-ical2org.nix home)
      (import ./environment userConfig)
      (import ./services userConfig)
      (import ./networking machine)
    ];

  # Use the GRUB 2 boot loader.
  boot = {
    loader.grub = {
      enable = true;
      version = 2;
      device = "/dev/sda";
    };

    supportedFilesystems = ["ntfs" "exfat"];
  };

  programs.ssh.startAgent = false;

  time.timeZone = "America/Vancouver";

  nix = {
    binaryCaches = caches;
    trustedBinaryCaches = caches;
    binaryCachePublicKeys = [
      "hydra.cryp.to-1:8g6Hxvnp/O//5Q1bjjMTd5RO8ztTsG8DKPOAg9ANr2g="
    ];
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

  nixpkgs.config = nixpkgsConfig;

  virtualisation.virtualbox.host.enable = true;
  virtualisation.docker.enable = true;

  security.setuidPrograms = [ "slock" ];

  users.extraUsers.jb55 = user;
  users.extraGroups.vboxusers.members = [ "jb55" ];
  users.extraGroups.docker.members = [ "jb55" ];

  users.defaultUserShell = zsh;
  users.mutableUsers = true;

  programs.zsh.enable = true;
}
 
