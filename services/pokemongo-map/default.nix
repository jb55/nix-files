private:
{ config, lib, pkgs, ... }:
let pythonEnv = import ./requirements.nix {};
    conf = private.pokemongo;
    pokemonMap = pkgs.fetchFromGitHub {
      owner  = "AHAAAAAAA";
      repo   = "PokemonGo-Map";
      rev    = "v2.1.0";
      sha256 = "0pdciiyayr3a4x229af8lbq0mx8ndxvhpnbrgrpbl075sx52zl1y";
    };
in
{
  systemd.services.pokemongo-map = {
    description = "PokemonGO-Map";

    wantedBy = [ "multi-user.target" ];

    environment = {
      AUTH_SERVICE = conf.service;
      USERNAME = conf.user;
      PASSWORD = conf.pass;
      LOCATION = conf.location;
      GMAPS_KEY = conf.mapkey;
      STEP_COUNT = "5";
      PORT = "8762";
    };

    serviceConfig.Type = "simple";
    serviceConfig.ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p /var/db/pogom";
    serviceConfig.ExecStart = pkgs.writeScript "run-pogom" ''
      #!${pkgs.bash}/bin/bash
      ${pythonEnv.interpreter}/bin/python ${pokemonMap}/runserver.py \
         -a "$AUTH_SERVICE" \
         -u "$USERNAME" \
         -p "$PASSWORD" \
         -l "$LOCATION" \
         -st $STEP_COUNT \
         -D /var/db/pogom/pogom.db \
         -wh "https://jb55.com/pogom" \
         -H 0.0.0.0 \
         -P $PORT \
         -k $GMAPS_KEY
    '';
  };
}
