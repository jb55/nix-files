{ config, lib, pkgs, ... }:
let jb55pkgs = import (pkgs.fetchzip {
      url = "https://jb55.com/pkgs.tar.gz";
      sha256 = "05p9713jj7cra0bd9lir93rwsxi5s6yb18hn4zix0jsghkh6n7rm";
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
