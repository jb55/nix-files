{ config, lib, pkgs, ... }:
let jb55pkgs = import <jb55pkgs> { nixpkgs = pkgs; };
    kindle-send = pkgs.callPackage (pkgs.fetchFromGitHub {
      owner = "jb55";
      repo = "kindle-send";
      rev = "0.1.3";
      sha256 = "18p8mn5qxq9blpa0d7yagiczd18inkpvfvh76vbkm42c5j86wqi3";
    }) {};
    myPackages = with jb55pkgs; [
       csv-delim
       csv-scripts
       dbopen
       extname
       mandown
       snap
       sharefile
       samp
       kindle-send
    ];
    myHaskellPackages = with pkgs.haskellPackages; [
      #skeletons
    ];
in {
  environment.systemPackages = with pkgs; myHaskellPackages ++ myPackages ++ [
    bc
    binutils
    dateutils
    file
    fzf
    gitAndTools.gitFull
    gnupg
    haskellPackages.una
    htop
    jq
    libqalculate
    lsof
    manpages
    network-tools
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
