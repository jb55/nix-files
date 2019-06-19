{ pkgs, to, bcli, addr }:

pkgs.writeScript "dca"
''
#!${pkgs.bash}/bin/bash

set -e

keybasesock=/run/user/1000/keybase/keybased.sock
wallet=''${BTCDCA_WALLET:-cc}
user=''${BTCDCA_RPCUSER:-rpcuser}
pass=''${BTCDCA_RPCPASS:-rpcpass}
amount=''${BTCDCA_AMOUNT:-$(cat /home/jb55/var/dca-amount)}
pair=''${BTCDCA_PAIR:-XXBTZCAD}
keybaseto=''${BTCDCA_KEYBASETO:-${to}}

price=$(${pkgs.curl}/bin/curl -sL "https://api.kraken.com/0/public/Ticker?pair=$pair" | ${pkgs.jq}/bin/jq -r ".result.$pair.a[0]")
invid=$(dd if=/dev/urandom bs=1 count=4 | ${pkgs.xxd}/bin/xxd -p | ${pkgs.libbitcoin-explorer}/bin/bx base58-encode)

address=${addr}

satsdec=$(${pkgs.bcalc}/bin/bcalc -n --price $price $amount fiat to sats)
sats=''${satsdec%.*}
btc=$(${pkgs.bcalc}/bin/bcalc -n $sats sats to btc)

msg=$(printf "Please send %s BTC to %s for \$%s @ \$%s\ne-transfer password is %s\nplease ACK to confirm. e-transfer will be sent when ACKed.\n" \
       "$btc" "$address" "$amount" "$price" "$invid")

if [ ! -e $keybasesock ]; then
   ${pkgs.systemd}/bin/systemctl --user restart keybase
fi

for user in $keybaseto; do
    ${pkgs.keybase}/bin/keybase chat send "$user" "$msg"
done
''
