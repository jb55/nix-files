{ pkgs ? (import <nixpkgs> {}).pkgs }:
with pkgs;
let
  f = { mkDerivation, base, bytestring, http-client
      , http-client-tls, lens, stdenv, taggy-lens, text, time, wreq
      }:
      mkDerivation rec {
        pname = "tunecore-trend-bot";
        version = "0.1.0.0";
        src = pkgs.fetchgit {
          url = http://git.zero.monster.cat/tunecore-trend-bot;
          rev = "64f660b71dbea2932fed8ee3217cc57926e92190";
          sha256 = "1r6ymprlw69i6c7q9r0k189waz5p35b7ah8msmf93p2ijpmvjjmy";
        };
        isLibrary = false;
        isExecutable = true;
        executableHaskellDepends = [
          base bytestring http-client http-client-tls lens taggy-lens text
          time wreq
        ];
        license = stdenv.lib.licenses.unfree;
      };

  haskellPackages = pkgs.haskellPackages;

in
   haskellPackages.callPackage f {}
