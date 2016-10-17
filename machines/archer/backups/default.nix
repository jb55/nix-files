extra:
{ config, lib, pkgs, ... }:
let pubkey = pkgs.fetchurl {
               url = "https://jb55.com/pgp.txt";
               sha256 = "012910961fb58b886fc44a8ebedba394240be4e17604703f3b094eef86d5aca5";
             };
in
{
  systemd.services.postgresql-backup = {
    description = "PostgreSQL backups";

    environment = {
      AWS_ACCESS_KEY_ID = extra.private.aws_access_key;
      AWS_SECRET_ACCESS_KEY = extra.private.aws_secret_key;
    };

    unitConfig.OnFailure = "notify-failed@%n.service";
    # Saturday morning? should be fine
    startAt = "Sat *-*-* 08:10:00";
    serviceConfig.ExecStart = let script = pkgs.writeScript "postgresql-backup" ''
      #!${pkgs.bash}/bin/bash
      set -euo pipefail

      filename="Monstercat-pgdev-$(date +%F-%H%M%z).sql.xz.gpg"

      ${pkgs.gnupg}/bin/gpg2 --import ${pubkey} || echo "already have key!"

      ${pkgs.postgresql}/bin/pg_dump Monstercat \
         | ${pkgs.pxz}/bin/pxz -T24 \
         | ${pkgs.gnupg}/bin/gpg2 \
              -e \
              --compress-level 0 \
              --yes \
              --no-tty \
              --output - \
              -r 0x6D3E2004415AF4A3 \
         | ${pkgs.awscli}/bin/aws s3 \
              cp - \
              "s3://data.monstercat.com/backups/pg-dev/$filename"

    '';
    in "${script}";
  };

}
