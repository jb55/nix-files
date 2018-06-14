{ config, lib, pkgs, ... }:
let mkfont = n: lesrc:
               pkgs.stdenv.mkDerivation rec {
                 name = "${n}-${version}";
                 src = pkgs.fetchurl lesrc;
                 version = "1.0";
                 phases = ["installPhase"];

                 installPhase = ''
                   mkdir -p $out/share/fonts/${n}
                   cp -v ${src} $out/share/fonts/${n}
                 '';
               };
    aldrich =
      mkfont "aldrich" {
        url = "https://jb55.com/s/bef303d9e370f941.ttf";
        sha256 = "ecc2fbf1117eed2d0b1bf32ee8624077577d568f1c785699353416b67b519227";
      };
    VarelaRound-Regular =
      mkfont "VarelaRound-Regular" {
        url = "https://jb55.com/s/c8bbd8415dea995f.ttf";
        sha256 = "c4327a38270780eb03d305de3514de62534262c73f9e7235eea6ce26904c2dc5";
      };
    Questrial =
      mkfont "Questrial" {
        url = "https://jb55.com/s/1ccac9ff5cb42fd7.ttf";
        sha256 = "294729bb4bf3595490d2e3e89928e1754a7bfa91ce91e1e44ecd18c974a6dbbc";
      };
    Comfortaa-Regular =
      mkfont "Comfortaa-Regular" {
        url = "https://jb55.com/s/a266c50144cbad1a.ttf";
        sha256 = "db5133b6a09c8eba78b29dc05019d8f361f350483d679fd8c668e1c657a303fc";
      };
    myfonts = [ aldrich VarelaRound-Regular Questrial Comfortaa-Regular ];
in
{
  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    enableCoreFonts = true;
    fontconfig.defaultFonts.serif = [ "Noto Serif" ];
    fontconfig.defaultFonts.monospace  = [ "Inconsolata" ];
    fontconfig.defaultFonts.sansSerif  = [ "Noto Sans" ];
    fonts = with pkgs; [
      corefonts
      inconsolata
      ubuntu_font_family
      emojione
      fira-code
      fira-mono
      kochi-substitute
      noto-fonts
      noto-fonts-emoji
      source-code-pro
      ipafont
    ] ++ myfonts;
  };
}
