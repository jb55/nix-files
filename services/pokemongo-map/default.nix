extra:
{ config, lib, pkgs, ... }:
let private   = extra.private;
    pythonEnv = import ./requirements.nix {};
    pokemonMap = pkgs.fetchFromGitHub {
      owner  = "jb55";
      repo   = "PokemonGo-Map";
      rev    = "a63721bfadc318b1f158f53e0cc532a4e16091ef";
      sha256 = "11m8h38glpbm2va4xxjfsvpigfmmjf531w1db2nqfccnkw872k75";
    };
    services = def: {
      "pogom-${def.subdomain}" = {
        description = "PokemonGO-Map, ${def.subdomain}";

        wantedBy = [ "multi-user.target" ];

        environment = {
          AUTH_SERVICE = def.service;
          USERNAME = def.user;
          PASSWORD = def.pass;
          LOCATION = def.location;
          GMAPS_KEY = def.mapkey;
          STEP_COUNT = "5";
          PORT = def.port;
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
            -D /var/db/pogom/pogom-${def.subdomain}.db \
            -wh "https://jb55.com/pogom" \
            -H 0.0.0.0 \
            -P $PORT \
            -k $GMAPS_KEY
        '';
      };
    };
in { systemd.services = lib.lists.fold (a: b: a // b) {} (map services private.pokemaps);
   }
