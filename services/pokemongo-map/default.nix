extra:
{ config, lib, pkgs, ... }:
let private   = extra.private;
    pythonEnv = import ./requirements.nix {};
    pokemonMap = pkgs.fetchFromGitHub {
      owner  = "jb55";
      repo   = "PokemonGo-Map";
      rev    = "00229d4c869c9c6928b390f82aae136d416c102f";
      sha256 = "17rh2dw488j7j6phfm4yyn0vr74id0lmnx362gnl9r5dmqmrizdg";
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
