{ userConfig, theme, icon-theme, extra }:
{ config, lib, pkgs, ... }:
let gtk2rc = pkgs.writeText "gtk2rc" ''
      gtk-icon-theme-name = "${icon-theme.name}"
      gtk-theme-name = "${theme.name}"

      binding "gtk-binding-menu" {
        bind "j" { "move-current" (next) }
        bind "k" { "move-current" (prev) }
        bind "h" { "move-current" (parent) }
        bind "l" { "move-current" (child) }
      }
      class "GtkMenuShell" binding "gtk-binding-menu"
    '';

    mypkgs = with pkgs; [
      #icon-theme.package
      #theme.package
      #skypeforlinux
      texlive.combined.scheme-full
      clipit
      clipmenu
      dmenu2
      dragon-drop
      dunst
      dynamic-colors
      emacs
      feh
      getmail # for getmail-gmail-xoauth-tokens
      gnome3.gnome-calculator
      gtk-engine-murrine
      lastpass-cli
      libnotify
      msmtp
      muchsync
      notmuch
      pandoc
      pinentry
      pavucontrol
      python37Packages.trezor
      qalculate-gtk
      qutebrowser
      rxvt_unicode-with-plugins
      signal-desktop
      simplescreenrecorder
      slock
      spotify
      userConfig
      vlc
      w3m
      wmctrl
      x11vnc
      xautolock
      xbindkeys
      xclip
      xdotool
      xlibs.xev
      xlibs.xmodmap
      xlibs.xset
      zathura
      colorpicker
      zoom-us
      postgresql # psql

      steam
      xboard
      steam-run
      dolphinEmu
      wine
    ];
in {

  # latest emacs overlay
  nixpkgs.overlays =  [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/emacs-overlay/archive/773a9f17db9296b45e6b7864d8cee741c8d0d7c7.tar.gz;
      sha256 = "157klv69myjmdgqvxv0avv32yfra3i21h5bxjhksvaii1xf3w1gp";
    }))
  ];

  environment.variables = lib.mkIf (!extra.is-minimal) {
    LC_TIME="en_DK.UTF-8";
    GDK_PIXBUF_MODULE_FILE = "${pkgs.librsvg.out}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache";
    GTK2_RC_FILES = "${gtk2rc}:${theme.package}/share/themes/${theme.name}/gtk-2.0/gtkrc:$GTK2_RC_FILES";
    GTK_DATA_PREFIX = "${theme.package}";
    GTK_EXEC_PREFIX = "${theme.package}";
    GTK_IM_MODULE = "xim";
    GTK_PATH = "${theme.package}:${pkgs.gtk3.out}";
    GTK_THEME = "${theme.name}";
    QT_STYLE_OVERRIDE = "GTK+";
  };

  environment.systemPackages = if extra.is-minimal then (with pkgs; [
    steam
    steam-run
    wine
    lastpass-cli
    rxvt_unicode-with-plugins
  ]) else mypkgs;

  security.wrappers = {
    slock.source = "${pkgs.slock}/bin/slock";
  };
}
