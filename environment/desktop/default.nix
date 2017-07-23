{ userConfig, theme, icon-theme }:
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
in {
  environment.variables = {
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

  environment.systemPackages = with pkgs; [
    gtk-engine-murrine
    shared_mime_info
    theme.package
    icon-theme.package

    clipit
    msmtp
    dragon-drop
    # dropbox-cli
    emacs
    gnome3.eog
    xfce.thunar
    pavucontrol
    pidgin-with-plugins
    rxvt_unicode-with-plugins
    scrot
    slock
    # spotify
    userConfig
    vlc
    weechat
    xautolock
    xbindkeys
    xdg_utils
    xlibs.xev
    xlibs.xmodmap
    xlibs.xset
    zathura
  ];

  security.wrappers = {
    slock.source = "${pkgs.slock}/bin/slock";
  };
}
