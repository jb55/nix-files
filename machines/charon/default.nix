{ config, lib, pkgs, ... }:
{
  imports = [
    ./networking
    ./hardware
    ./nginx
  ];
}
