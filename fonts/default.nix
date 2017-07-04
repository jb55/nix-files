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
      aldrich
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
    ];
  };
}
