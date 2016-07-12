{ config, lib, pkgs, ... }:
{
  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    enableCoreFonts = true;
    fonts = with pkgs; [
      corefonts
      inconsolata
      ubuntu_font_family
      emojione
      fira-code
      fira-mono
      kochi-substitute
      source-code-pro
      ipafont
    ];
  };
}
