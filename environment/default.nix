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
  documentation.dev.enable = true;
  documentation.man.enable = true;

  environment.systemPackages = with pkgs; myHaskellPackages ++ myPackages ++ [
    bc
    binutils
    dateutils
    file
    fzf
    gitFull
    gnupg
    haskellPackages.una
    htop
    jq
    libqalculate
    lsof
    nixops
    nix-repl
    parallel
    patchelf
    pv
    python
    ranger
    ripgrep
    rsync
    shellcheck
    unzip
    vim
    wget
    zip
  ];
}
