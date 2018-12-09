{ config, lib, pkgs, ... }:
{
  services.spruned = {
    enable = false;
    dataDir = "/zbig/spruned";
    network = "mainnet";
    extraArguments = "--debug";
  };

  services.bitcoind.networks = {
    testnet = {
      testnet = true;
      dataDir = "/var/lib/bitcoin-testnet";
      extraConfig = ''
        txindex=1
        rpcuser=rpcuser
        rpcpassword=rpcpass
        rpcallowip=1
        rpcbind=172.24.242.111
        rpcbind=10.147.20.220
        rpcbind=127.0.0.1
        rpcport=6533
      '';
    };

    mainnet = {
      dataDir = "/var/lib/bitcoin";
      extraConfig = ''
        txindex=1
        rpcuser=rpcuser
        rpcpassword=rpcpass
        rpcallowip=1
        rpcbind=172.24.242.111
        rpcbind=10.147.20.220
        rpcbind=127.0.0.1
        rpcport=6532
      '';
    };
  };

  services.clightning.networks = {
    testnet = {
      dataDir = "/home/jb55/.lightning";

      config = ''
        fee-per-satoshi=9000
        bitcoin-rpcuser=rpcuser
        bitcoin-rpcpassword=rpcpass
        bitcoin-rpcconnect=127.0.0.1
        bitcoin-rpcport=6533
        bind-addr=0.0.0.0:9736
        announce-addr=24.84.152.187:9736
        network=testnet
        log-level=debug
        alias=@jb55
        rgb=ff0000
      '';
    };

    mainnet = {
      dataDir = "/home/jb55/.lightning-bitcoin";

      config = ''
        bitcoin-rpcuser=rpcuser
        bitcoin-rpcpassword=rpcpass
        bitcoin-rpcconnect=127.0.0.1
        bitcoin-rpcport=6532
        fee-per-satoshi=9000
        bind-addr=0.0.0.0:9735
        announce-addr=24.84.152.187:9735
        network=bitcoin
        log-level=debug
        alias=@jb55
        rgb=ff0000
      '';
    };
  };

}
