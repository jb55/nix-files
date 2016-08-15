{ config, lib, pkgs, ... }:
let jb55pkgs = import (pkgs.fetchzip {
      url = "https://jb55.com/pkgs.tar.gz";
      sha256 = "0h7priginnlklnchbvqn11g1zx9848vgkcqw98wi7rwvzlk1651j";
    }) { nixpkgs = pkgs; };
    myPackages = builtins.attrValues jb55pkgs;
    myHaskellPackages = with pkgs.haskellPackages; [
      skeletons
    ];
in {
  environment.systemPackages = with pkgs; myPackages ++ [
    bc
    file
    gist
    gitAndTools.git-extras
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
