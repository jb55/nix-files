{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.hoogle;
  ghcWithHoogle = pkgs.haskellPackages.ghcWithHoogle;

in {

  options.services.hoogle = {
    enable = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = ''
        Enable Hoogle to run a documentation server for a list of haskell packages
      '';
    };

    port = mkOption {
      type = types.int;
      default = 8080;
      description = ''
        Number of the port Hoogle will be listening to.
      '';
    };

    packages = mkOption {
      default = hp: [];
      example = "hp: with hp; [ text lens ]";
      description = ''
        A function that takes a haskell package set and returns a list of
        packages from it.
      '';
    };

    haskellPackages = mkOption {
      description = "Which haskell package set to use.";
      example = "pkgs.haskell.packages.ghc704";
      default = pkgs.haskellPackages;
      type = types.attrs;
    };
  };

  config = mkIf cfg.enable {
    systemd.services.hoogle = {
      description = "Hoogle Haskell documentation search";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Restart = "always";
        ExecStart =
          let env = cfg.haskellPackages.ghcWithHoogle cfg.packages;
              hoogleEnv = pkgs.buildEnv {
                name = "hoogleServiceEnv";
                paths = [env];
              };
          in ''
            ${hoogleEnv}/bin/hoogle server --local -p ${toString cfg.port}
          '';
      };
    };
  };

}
