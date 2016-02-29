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
  environment.systemPackages = with pkgs; [
    bc
    file
    #gist
    #gitAndTools.git-extras
    gitFull
    htop
    lsof
    rsync
    silver-searcher
    vim
    wget
    xclip
  ];
}
