{ config, lib, pkgs, ... }:
let certs = [ ./flynn-dev.cer
              ./flynn-prod.cer
            ];
in {
  security.pki.certificates = map builtins.readFile certs;
}
