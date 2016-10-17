{ config, lib, pkgs, ... }:
{
  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    enableCoreFonts = true;
    fontconfig.defaultFonts.serif = [ "Noto Serif" ];
    fontconfig.defaultFonts.monospace  = [ "Noto Mono" ];
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
    ];
  };
}
