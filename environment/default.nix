userConfig:
{ config, lib, pkgs, ... }:

let jb55pkgs = import (pkgs.fetchzip {
      url = "https://jb55.com/pkgs.tar.gz";
      sha256 = "12sii14xzy4vix4bmm1amg9bc54fl563pri2fqn99bss5ga1s6jn";
    }) { nixpkgs = pkgs; };
    myPackages = builtins.attrValues jb55pkgs;
    myHaskellPackages = with pkgs.haskellPackages; [
      skeletons
    ];
in {
  environment.x11Packages = with pkgs; [
    gtk
  ];

  environment.variables = {
    # GTK2_RC_FILES = "${pkgs.numix-gtk-theme}/share/themes/Numix/gtk-2.0/gtkrc";
    GTK_DATA_PREFIX = "${config.system.path}";
    GTK_THEME = "Vertex-Dark";
    QT_STYLE_OVERRIDE = "GTK+";
  };

  environment.systemPackages = with pkgs; myHaskellPackages ++ myPackages ++ [
    gnome.gnome_icon_theme
    gtk-engine-murrine
    hicolor_icon_theme
    shared_mime_info
    arc-gtk-theme
    theme-vertex

    bc
    binutils
    chromium
    clipit
    dmenu
    dragon-drop
    dropbox-cli
    emacs
    file
    fzf
    gist
    gitAndTools.git-extras
    gitFull
    gnome3.eog
    gnome3.nautilus
    gnome3.gnome-calculator
    gnupg
    haskellPackages.taffybar
    hsetroot
    htop
    lsof
    mpc_cli
    nix-repl
    patchelf
    pavucontrol
    pidgin
    pv
    redshift
    rsync
    rxvt_unicode
    scrot
    silver-searcher
    slock
    spotify
    subversion
    twmn
    unzip
    userConfig
    vim
    vlc
    wget
    weechat
    xautolock
    xbindkeys
    xclip
    xdg_utils
    xlibs.xev
    xlibs.xmodmap
    xlibs.xset
    zathura
    zip

  ];
}
