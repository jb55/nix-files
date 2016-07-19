theme:
{ config, lib, pkgs, ... }:
let
in {
  environment.variables = theme.environment;

  environment.systemPackages = with pkgs; [
    chromium
    clipit
    dragon-drop
    dropbox-cli
    emacs25pre
    gnome3.eog
    gnome3.nautilus
    haskellPackages.taffybar
    pavucontrol
    pidgin
    rxvt_unicode
    scrot
    slock
    spotify
    vlc
    weechat
    xautolock
    xbindkeys
    xdg_utils
    xlibs.xev
    xlibs.xmodmap
    xlibs.xset
    zathura
  ] ++ theme.packages;

  security.setuidPrograms = [ "slock" ];
}
