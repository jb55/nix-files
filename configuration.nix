# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let machine = "archer";
    isDesktop = machine != "charon";
    machinePath = p: let m = "/" + machine;
                     in ./machines + m + p;
    machineConfig = import (machinePath "/config") pkgs;
    zsh = "${pkgs.zsh}/bin/zsh";
    nixpkgsConfig = import ./nixpkgs/config.nix;
    home = "/home/jb55";
    private = import ./private.nix;
    theme = rec {
      packages = with pkgs; [
        gnome.gnome_icon_theme
        gtk-engine-murrine
        shared_mime_info
        icon-package
        package
      ];
      gtk2rc = pkgs.writeText "gtk2rc" ''
        gtk-icon-theme-name = "${icons}"
        gtk-theme-name = "${name}"

        binding "gtk-binding-menu" {
          bind "j" { "move-current" (next) }
          bind "k" { "move-current" (prev) }
          bind "h" { "move-current" (parent) }
          bind "l" { "move-current" (child) }
        }
        class "GtkMenuShell" binding "gtk-binding-menu"
      '';
      environment = {
        GDK_PIXBUF_MODULE_FILE = "${pkgs.librsvg.out}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache";
        GTK_DATA_PREFIX = "${package}";
        GTK_EXEC_PREFIX = "${package}";
        GTK_PATH = "${package}:${pkgs.gtk3.out}";
        GTK_THEME = "${name}";
        QT_STYLE_OVERRIDE = "GTK+";
        GTK2_RC_FILES = "${gtk2rc}:${package}/share/themes/${name}/gtk-2.0/gtkrc:$GTK2_RC_FILES";
      };
      package = pkgs.theme-vertex;
      icon-package = pkgs.numix-icon-theme;
      name  = "Vertex-Dark";
      icons = "Numix";
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
      (import ./environment/desktop theme )
      (import ./timers/sync-ical2org.nix home)
      (import ./services/desktop theme)
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

  i18n.consoleUseXkbConfig = true;

  programs.zsh.enable = true;

}
