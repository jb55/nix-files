userConfig:
{ config, lib, pkgs, ... }:
{
  environment.variables = {
    GTK2_RC_FILES = "${config.system.path}";
    GTK_DATA_PREFIX = "${config.system.path}";
    GTK_THEME = "Vertex-Dark";
    QT_STYLE_OVERRIDE = "GTK+";
  };

  environment.systemPackages = with pkgs; [
    gnome.gnome_icon_theme
    gtk-engine-murrine
    numix-icon-theme
    hicolor_icon_theme
    shared_mime_info
    theme-vertex

    chromium
    clipit
    dragon-drop
    dropbox-cli
    emacs
    haskellPackages.taffybar
    pavucontrol
    pidgin
    rxvt_unicode
    scrot
    slock
    spotify
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

  security.setuidPrograms = [ "slock" ];
}
