extra:
{ config, lib, pkgs, ... }:

let
  bitcoinDataDir = "/zbig/bitcoin";

  base-bitcoin-conf = ''
    txindex=1
    rpcuser=rpcuser
    rpcpassword=rpcpass
    rpcallowip=172.24.227.91
    rpcallowip=127.0.0.1
    rpcbind=172.24.242.111
    rpcbind=127.0.0.1
    rpcbind=[::1]
    rpcport=8332
    proxy=127.0.0.1:9050
    wallet=old-wallet
    wallet=trezor
    wallet=cc
    wallet=clightning
  '';

  bcli = "${pkgs.altcoins.bitcoind}/bin/bitcoin-cli --datadir=${bitcoinDataDir} --conf=${base-bitcoin-conf-file} --rpcuser=rpcuser --rpcpassword=rpcpass";

  bitcoin-conf = ''
    ${base-bitcoin-conf}
    walletnotify=${walletemail} %s %w
  '';

  base-bitcoin-conf-file = pkgs.writeText "bitcoin-base.conf" base-bitcoin-conf;
  bitcoin-conf-file = pkgs.writeText "bitcoin.conf" bitcoin-conf;

  dca = import ./dca.nix {
    inherit pkgs bcli;
    to = "jb55 ${extra.private.btc-supplier}";
    addr = extra.private.btc-supplier-addr;
  };
  walletemail = import ./walletemail.nix { inherit pkgs bcli; };
in
{

  systemd.user.services.bitcoin-dca =  {
    enable = true;
    description = "bitcoin dca";

    serviceConfig = {
      Type = "oneshot";
      ExecStart = dca;
    };

    startAt = "Thu *-*-* 10:00:00";
  };

  services.bitcoind = {
    enable = true;
    dataDir = bitcoinDataDir;
    configFile = bitcoin-conf-file;
    user = "jb55";
    group = "users";
  };

  services.bitcoind.package = pkgs.lib.overrideDerivation pkgs.altcoins.bitcoind (attrs: {
      src = pkgs.fetchFromGitHub {
        owner  = "jb55";
        repo   = "bitcoin";
        sha256 = "078a7l7n75kfzi5k3ffg8him6w2dr9mksqyvzaypb8ccai88sp76";
        rev    = "e45893691257e548f3836bc131a19e67e6d056bd";
      };

      enableParallelBuilding = true;
  });

  services.clightning.networks = {
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

}
