{ config, lib, pkgs, ... }:
let jb55pkgs = import <jb55pkgs> { inherit pkgs; };
    kindle-send = pkgs.callPackage (pkgs.fetchFromGitHub {
      owner = "jb55";
      repo = "kindle-send";
      rev = "0.2.1";
      sha256 = "0xd86s2smjvlc7rlb6rkgx2hj3c3sbcz3gs8rf93x69jqdvwb6rr";
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
    bat
    bc
    binutils
    dateutils
    file
    fzf
    gitAndTools.gitFull
    gnupg
    htop
    jq
    lsof
    manpages
    network-tools
    parallel
    patchelf
    pv
    python
    ripgrep
    rsync
    screen
    unzip
    vim
    wget
    zip
    zstd
  ];
}
