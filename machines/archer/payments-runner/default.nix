extra:
{ config, lib, pkgs, ... }:
let
  monstercatpkgs = import <monstercatpkgs> {};
  payments-processor = monstercatpkgs.payments-processor;
  payment-scripts = monstercatpkgs.payment-scripts;
in
{
}
