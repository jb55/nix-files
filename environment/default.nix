{ config, lib, pkgs, ... }:
let jb55pkgs = import <jb55pkgs> { inherit pkgs; };
    kindle-send = pkgs.callPackage (pkgs.fetchFromGitHub {
      owner = "jb55";
      repo = "kindle-send";
      rev = "0.2.1";
      sha256 = "0xd86s2smjvlc7rlb6rkgx2hj3c3sbcz3gs8rf93x69jqdvwb6rr";
    }) {};
    myPackages = with jb55pkgs; [
       bcalc
       csv-delim
       csv-scripts
       dbopen
       extname
       kindle-send
       mandown
       samp
       sharefile
       snap
       btcs
    ];
    myHaskellPackages = with pkgs.haskellPackages; [
      #skeletons
    ];
in {
  environment.systemPackages = with pkgs; myHaskellPackages ++ myPackages ++ [
    aspell
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science
    bat
    bc
    binutils
    dateutils
    file
    fzf
    git-tools
    gnupg
    groff
    haskellPackages.una
    htop
    imagemagick
    jq
    libbitcoin-explorer
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
    screen
    shellcheck
    unzip
    vim
    weechat
    wget
    zip
    zstd
  ];
}
