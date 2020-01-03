# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let machine = "monad";
    isDesktop = true;
    machinePath = p: let m = "/" + machine;
                     in ./machines + m + p;
    machineConfig = import (machinePath "/config") pkgs;
    userConfig = pkgs.callPackage ./nixpkgs/dotfiles.nix {
      machineSessionCommands = machineConfig.sessionCommands;
    };
    extra = {
      git-server = import ./misc/git-server.nix;
      util       = import ./misc/util.nix { inherit pkgs; };
      private    = import ./private.nix;
      machine    = machineConfig;
    };
    util = extra.util;
    caches = [ "https://cache.nixos.org" ];
    zsh = "${pkgs.zsh}/bin/zsh";
    composeKey = if machine == "quiver" then "ralt" else "rwin";
    nixpkgsConfig = import ./nixpkgs/config.nix;
    home = "/home/jb55";
    isDark = false;
    theme = if isDark then {
      package = pkgs.theme-vertex;
      name = "Vertex-Dark";
    }
    else {
      package = pkgs.arc-theme;
      name = "Arc";
    };
    icon-theme = {
      package = pkgs.numix-icon-theme;
      name = "Numix";
    };
    user = {
        name = "jb55";
        group = "users";
        uid = 1000;
        extraGroups = [ "wheel" "dialout" ];
        createHome = true;
        openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDAvMdnEEAd/ZQM+pYp6ZYG/1NPE/HSwIKoec0/QgGy4UlO0EvpWWhxPaV0HlNUFfwiHE0I2TwHc+KOKcG9jcbLAjCk5rvqU7K8UeZ0v/J83bQh78dr4le09WLyhczamJN0EkNddpCyUqIbH0q3ISGPmTiW4oQniejtkdJPn2bBwb3Za8jLzlh2UZ/ZJXhKvcGjQ/M1+fBmFUwCp5Lpvg0XYXrmp9mxAaO+fxY32EGItXcjYM41xr/gAcpmzL5rNQ9a9YBYFn2VzlpL+H7319tgdZa4L57S49FPQ748paTPDDqUzHtQD5FEZXe7DZZPZViRsPc370km/5yIgsEhMPKr jb55"
        ];
        home = home;
        shell = zsh;
      };
in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./certs
      (import ./services extra)
      ./environment
      (import ./networking machine)
      (import (machinePath "") extra)
    ] ++ (if isDesktop then [
      ./hardware/desktop
      #./wayland
      ./fonts
      (import ./environment/desktop { inherit userConfig theme icon-theme; })
      (import ./services/desktop { inherit extra util composeKey userConfig theme icon-theme; })
    ] else []);

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;

  systemd.extraConfig = ''
    DefaultTimeoutStopSec=10s
    DefaultTimeoutStartSec=20s
  '';

  documentation.nixos.enable = false;

  programs.ssh.startAgent = true;

  time.timeZone = "America/Vancouver";

  nixpkgs.config = nixpkgsConfig;

  nix.useSandbox = machine != "charon";
  nix.trustedUsers = [ "root" "jb55" ];

  users.extraUsers.jb55 = user;
  users.extraGroups.docker.members = [ "jb55" ];

  users.defaultUserShell = zsh;
  users.mutableUsers = true;

  i18n.consoleUseXkbConfig = true;

  programs.zsh.enable = true;
}
