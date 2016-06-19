{ config, lib, pkgs, ... }:
{
  imports = [
    ./networking
    ./hardware
    ./environment
  ];
}
