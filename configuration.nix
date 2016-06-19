# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let machine = "charon";
    isDesktop = machine != "charon";
    machinePath = p: let m = "/" + machine;
                     in ./machines + m + p;
    machineConfig = import (machinePath "/config") pkgs;
    userConfig = pkgs.callPackage ./nixpkgs/dotfiles.nix {
      machineSessionCommands = "";
    };
    zsh = "${pkgs.zsh}/bin/zsh";
    nixpkgsConfig = import ./nixpkgs/config.nix;
    home = "/home/jb55";
    theme = {
      package = pkgs.theme-vertex;
      name = "Vertex-Dark";
    };
    icon-theme = {
      package = pkgs.numix-icon-theme;
      name = "Numix";
    };
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
      ./services
      ./environment
      (import ./networking machine)
      (machinePath "")
    ] ++ (if isDesktop then [
      # ./services/hoogle
      ./hardware/desktop
      ./fonts
      (import ./environment/desktop { inherit userConfig theme icon-theme; })
      (import ./timers/sync-ical2org.nix home)
      (import ./services/desktop { inherit userConfig theme icon-theme; })
    ] else []);

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;

  programs.ssh.startAgent = !isDesktop;

  time.timeZone = "America/Vancouver";

  nixpkgs.config = nixpkgsConfig;

  virtualisation.docker.enable = true;

  users.extraUsers.jb55 = user;
  users.extraGroups.docker.members = [ "jb55" ];

  users.defaultUserShell = zsh;
  users.mutableUsers = true;

  programs.zsh.enable = true;
}
