{ config, lib, pkgs, ... }:
let jb55pkgs = import (pkgs.fetchzip {
      url = "https://jb55.com/pkgs.tar.gz";
      sha256 = "1fgwgfp6fc94a11vxn6chlrv2m2kj0snrxyq77hwxrkn2jsaiaiw";
    }) { nixpkgs = pkgs; };
    myPackages = builtins.attrValues jb55pkgs;
    myHaskellPackages = with pkgs.haskellPackages; [
      skeletons
    ];
in {
  environment.systemPackages = with pkgs; myHaskellPackages ++ myPackages ++ [
    bc
    binutils
    file
    fzf
    gist
    gitAndTools.git-extras
    gitFull
    gnupg
    htop
    lsof
    nix-repl
    patchelf
    pv
    rsync
    silver-searcher
    subversion
    unzip
    vim
    wget
    xclip
    zip
  ];
}
