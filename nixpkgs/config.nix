{ pkgs }:
let haskellOverrides = import ./haskell-overrides.nix;
    myPackages = import ./my-packages.nix;
in {
  allowUnfree = true;
  allowUnfreeRedistributable = true;
  allowBroken = false;
  zathura.useMupdf = true;

  firefox = {
    enableGoogleTalkPlugin = true;
    enableAdobeFlash = true;
  };

  chromium = {
    enablePepperFlash = true; # Chromium's non-NSAPI alternative to Adobe Flash
    enablePepperPDF = false;
  };

  packageOverrides = super: rec {

    haskellPackages = super.haskellPackages.override {
      overrides = haskellOverrides pkgs;
    };

    pidgin-with-plugins = super.pidgin-with-plugins.override {
      plugins = (with super; [ pidginotr pidginwindowmerge pidgin-skypeweb pidgin-opensteamworks ]);
    };

    haskellEnvHoogle = haskellEnvFun {
      name = "haskellEnvHoogle";
      withHoogle = true;
    };

    haskellEnv = haskellEnvFun {
      name = "haskellEnv";
      withHoogle = false;
    };

    haskellToolsEnv = super.buildEnv {
      name = "haskellTools";
      paths = haskellTools haskellPackages;
    };

    haskellEnvFun = { withHoogle ? false, compiler ? null, name }:
      let hp = if compiler != null
                 then super.haskell.packages.${compiler}
                 else haskellPackages;

          ghcWith = if withHoogle
                      then hp.ghcWithHoogle
                      else hp.ghcWithPackages;

      in super.buildEnv {
        name = name;
        paths = [(ghcWith myHaskellPackages)];
      };

    haskellTools = hp: with hp; [
      #ghc-mod
      #hdevtools
      alex
      cabal-install
      cabal2nix
      ghc-core
      ghc-mod
      happy
      hasktags
      hindent
      hlint
      pointfree
      stack
      structured-haskell-mode
      super.multi-ghc-travis
    ];

    myHaskellPackages = hp: with hp; [
      aeson
      async
      attoparsec
      bifunctors
      bitcoin-api
      bitcoin-api-extra
      bitcoin-block
      bitcoin-script
      bitcoin-tx
      blaze-builder
      blaze-builder-conduit
      blaze-builder-enumerator
      blaze-html
      blaze-markup
      blaze-textual
      Boolean
      cased
      cassava
      cereal
      comonad
      comonad-transformers
      compact-string-fix
      directory_1_2_4_0
      dlist
      dlist-instances
      doctest
      exceptions
      failure
      fingertree
      flexible
      flexible-instances
      foldl
      free
      hamlet
      hashable
      hspec
      hspec-expectations
      html
      HTTP
      http-client
      http-date
      http-types
      HUnit
      io-memoize
      keys
      language-bash
      language-c
      language-javascript
      lens
      lens-action
      lens-aeson
      lens-datetime
      lens-family
      lens-family-core
      lifted-async
      lifted-base
      linear
      list-extras
      list-t
      logict
      mime-mail
      mime-types
      MissingH
      mmorph
      monad-control
      monad-coroutine
      monadloc
      monad-loops
      monad-par
      monad-par-extras
      monad-stm
      money
      mongoDB
      monoid-extras
      network
      newtype
      numbers
      optparse-applicative
      parsec
      parsers
      pcg-random
      persistent
      persistent-mongoDB
      persistent-template
      pipes
      pipes-async
      pipes-attoparsec
      pipes-binary
      pipes-bytestring
      pipes-concurrency
      pipes-csv
      pipes-extras
      pipes-group
      pipes-http
      pipes-mongodb
      pipes-network
      pipes-parse
      pipes-safe
      pipes-shell
      pipes-text
      pipes-wai
      posix-paths
      postgresql-simple
      pretty-show
      profunctors
      QuickCheck
      random
      reducers
      reflection
      regex-applicative
      regex-base
      regex-compat
      regex-posix
      regular
      relational-record
      resourcet
      retry
      rex
      safe
      SafeSemaphore
      sbv
      scotty
      semigroupoids
      semigroups
      shake
      shakespeare
      shelly
      simple-reflect
      speculation
      split
      Spock
      spoon
      stm
      stm-chans
      stm-stats
      streaming
      streaming-bytestring
      streaming-wai
      strict
      stringsearch
      strptime
      syb
      system-fileio
      system-filepath
      tagged
      taggy
      taggy-lens
      tar
      tardis
      tasty
      tasty-hspec
      tasty-hunit
      tasty-quickcheck
      tasty-smallcheck
      temporary
      test-framework
      test-framework-hunit
      text
      text-format
      time
      tinytemplate
      transformers
      transformers-base
      turtle
      uniplate
      unix-compat
      unordered-containers
      uuid
      vector
      void
      wai
      warp
      wreq
      xhtml
      yaml
      zippers
      zlib
    ];
  } // myPackages (with pkgs.stdenv; { inherit pkgs mkDerivation; });
}
