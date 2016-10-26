{ config, lib, pkgs, ... }:
let jb55pkgs = import <jb55pkgs> { nixpkgs = pkgs; };
    myPackages = with jb55pkgs; [
       csv-delim
       csv-scripts
       dbopen
       extname
       mandown
       snap
       sharefile
       samp
    ];
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
