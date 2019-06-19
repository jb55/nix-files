{ pkgs, bcli }:

pkgs.writeScript "walletemail" ''
#!${pkgs.bash}/bin/bash

set -e

txid="$1"
wallet="$2"

from="Bitcoin Wallet <bitcoind@monad>"
to="William Casarin <jb55@jb55.com>"
subject="Wallet notification"
keys="-r 0x8860420C3C135662EABEADF96342E010C44A6337 -r 0x5B2B1E4F62216BC74362AC61D4FBA2FC4535A2A9 -r 0xE02D3FD4EB4585A63531C1D0E1BFCB90A1FF7A1C"

tx="$(${bcli} -rpcwallet=$wallet gettransaction "$txid" true)"
address="$(${pkgs.jq}/bin/jq -r '.details[0].address' <<<"$tx")"
details="$(${pkgs.jq}/bin/jq -r '.details[] | [.address, .category, .amount, .label] | @csv' <<<"$tx")"
keypath="$(${bcli} -rpcwallet=$wallet getaddressinfo "$address" | ${pkgs.jq}/bin/jq -r .hdkeypath)"

amount="$(${pkgs.jq}/bin/jq -r '.amount' <<<"$tx")"
confs="$(${pkgs.jq}/bin/jq -r '.confirmations' <<<"$tx")"

time="$(date -d @$(${pkgs.jq}/bin/jq -r '.time' <<<"$tx"))"
received="$(date -d @$(${pkgs.jq}/bin/jq -r '.timereceived' <<<"$tx"))"

export GNUPGHOME=/zbig/bitcoin/gpg

msg="$(printf "txid: %s\n\naddress: %s\n\namount: %s\n\nconfirmations: %d\n\nwallet: %s\n\ntime: %s\n\nreceived: %s\n\nkeypath: %s\n\n%s\n\n\n%s" \
              "$txid" "$address" "$amount" "$confs" "$wallet" "$time" "$received" "$keypath" "$details" "$tx" )"

enctx="$(printf "Content-Type: text/plain\n\n%s\n" "$msg" | ${pkgs.gnupg}/bin/gpg --yes --always-trust --encrypt --armor $keys)"

{
cat <<EOF
From: $from
To: $to
Subject: $subject
MIME-Version: 1.0
Content-Type: multipart/encrypted; boundary="=-=-=";
  protocol="application/pgp-encrypted"

--=-=-=
Content-Type: application/pgp-encrypted

Version: 1

--=-=-=
Content-Type: application/octet-stream

$enctx
--=-=-=--
EOF
} | /run/current-system/sw/bin/sendmail --file /zbig/bitcoin/gpg/.msmtprc -oi -t

printf "sent walletnotify email for %s\n" "$txid"
''
