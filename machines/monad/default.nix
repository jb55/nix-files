{ config, lib, pkgs, ... }:
{
  imports = [
    ./networking
    ./hardware
  ];
}
