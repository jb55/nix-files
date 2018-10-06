{ config, lib, pkgs, ... }:
let jb55pkgs = import <jb55pkgs> { nixpkgs = pkgs; };
    kindle-send = pkgs.callPackage (pkgs.fetchFromGitHub {
      owner = "jb55";
      repo = "kindle-send";
      rev = "v0.1";
      sha256 = "1mivxvnzansmyrnk8x7jn1975hwb0nqly9wdsbs2ppsajd4z97l8";
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
  documentation.dev.enable = true;
  documentation.man.enable = true;

  environment.systemPackages = with pkgs; myHaskellPackages ++ myPackages ++ [
    bc
    binutils
    dateutils
    file
    fzf
    git
    gnupg
    haskellPackages.una
    htop
    jq
    libqalculate
    lsof
    nixops
    network-tools
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
