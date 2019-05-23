{ config, lib, pkgs, ... }:

let
  bitcoinDataDir = "/zbig/bitcoin";

  base-bitcoin-conf = ''
    txindex=1
    rpcuser=rpcuser
    rpcpassword=rpcpass
    rpcallowip=172.24.129.211
    rpcallowip=127.0.0.1
    rpcbind=172.24.242.111
    rpcbind=127.0.0.1
    rpcbind=[::1]
    rpcport=8332
    proxy=127.0.0.1:9050
    wallet=trezor
  '';

  bitcoin-conf = ''
    ${base-bitcoin-conf}
    walletnotify=${walletemail} %s
  '';

  base-bitcoin-conf-file = pkgs.writeText "bitcoin-base.conf" base-bitcoin-conf;
  bitcoin-conf-file = pkgs.writeText "bitcoin.conf" bitcoin-conf;

  walletemail = pkgs.writeScript "walletemail" ''
  #!${pkgs.bash}/bin/bash

  set -e

  txid="$1"
  wallet=trezor
  from="Bitcoin Wallet <bitcoind@monad>"
  to="William Casarin <jb55@jb55.com>"
  subject="Wallet notification"
  keys="-r 0x8860420C3C135662EABEADF96342E010C44A6337 -r 0x5B2B1E4F62216BC74362AC61D4FBA2FC4535A2A9 -r 0xE02D3FD4EB4585A63531C1D0E1BFCB90A1FF7A1C"

  tx="$(${pkgs.altcoins.bitcoind}/bin/bitcoin-cli --datadir=${bitcoinDataDir} \
    --conf=${base-bitcoin-conf-file} --rpcuser=rpcuser --rpcpassword=rpcpass -rpcwallet="$wallet" gettransaction "$txid" true)"

  export GNUPGHOME=/zbig/bitcoin/gpg
  enctx="$(printf "Content-Type: text/plain\n\n%s\n" "$tx" | ${pkgs.gnupg}/bin/gpg --yes --always-trust --encrypt --armor $keys)"

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
  '';
in
{

  services.spruned = {
    enable = false;
    dataDir = "/zbig/spruned";
    network = "mainnet";
    extraArguments = "--debug";
  };

  services.bitcoind.networks = {
    mainnet = {
      dataDir = bitcoinDataDir;
      extraConfig = bitcoin-conf;
    };

    # testnet = {
    #   testnet = true;
    #   dataDir = "/zbig/bitcoin-testnet";
    #   extraConfig = ''
    #     [test]
    #     txindex=1
    #     rpcuser=rpcuser
    #     rpcpassword=rpcpass
    #     rpcallowip=172.24.129.211
    #     rpcallowip=127.0.0.1
    #     rpcbind=172.24.242.111
    #     rpcbind=127.0.0.1
    #     rpcport=6533
    #   '';
    # };
  };

  services.clightning.networks = {
    # testnet = {
    #   dataDir = "/home/jb55/.lightning";

    #   config = ''
    #     fee-per-satoshi=9000
    #     bitcoin-rpcuser=rpcuser
    #     bitcoin-rpcpassword=rpcpass
    #     bitcoin-rpcconnect=127.0.0.1
    #     bitcoin-rpcport=6533
    #     bind-addr=0.0.0.0:9736
    #     announce-addr=24.84.152.187:9736
    #     network=testnet
    #     log-level=debug
    #     alias=bitsbacker.com
    #     rgb=ff0000
    #   '';
    # };

    mainnet = {
      dataDir = "/home/jb55/.lightning-bitcoin";

      config = ''
        bitcoin-rpcuser=rpcuser
        bitcoin-rpcpassword=rpcpass
        bitcoin-rpcconnect=127.0.0.1
        bitcoin-rpcport=8332
        fee-per-satoshi=900
        bind-addr=0.0.0.0:9735
        announce-addr=24.84.152.187:9735
        network=bitcoin
        log-level=debug
        alias=bitsbacker.com
        rgb=ff0000
      '';
    };
  };

  # systemd.user.services.clightning-testnet-rpc-tunnel = {
  #   description = "clightning testnet rpc tunnel";
  #   wantedBy = [ "default.target" ];
  #   after    = [ "default.target" ];

  #   serviceConfig.ExecStart = ''
  #     ${pkgs.socat}/bin/socat -d -d TCP-LISTEN:7879,fork,reuseaddr UNIX-CONNECT:/home/jb55/.lightning/lightning-rpc
  #   '';
  # };

  # services.electrs.enable = true;
  # services.electrs.dataDir = "/zbig/electrs";
  # services.electrs.bitcoinDataDir = bitcoinDataDir;
  # services.electrs.high-memory = true;

  systemd.user.services.clightning-rpc-tunnel = {
    description = "clightning mainnet rpc tunnel";
    wantedBy = [ "default.target" ];
    after    = [ "default.target" ];

    serviceConfig.ExecStart = ''
      ${pkgs.socat}/bin/socat -d -d TCP-LISTEN:7878,fork,reuseaddr UNIX-CONNECT:/home/jb55/.lightning-bitcoin/lightning-rpc
    '';
  };

}
