{ pkgs }:
let haskellOverrides = import ./haskell-overrides.nix;
in {
  allowUnfree = true;
  allowBroken = false;
  zathura.useMupdf = true;

  packageOverrides = super:
  let haskellPackages = super.haskellPackages.override {
    overrides = haskellOverrides pkgs;
  };
  in rec {
    inherit haskellPackages;

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

    haskellEnvFun = { withHoogle ? false, withPackages ? true, compiler ? null, name }:
      let hp = if compiler != null
                 then super.haskell.packages.${compiler}
                 else haskellPackages;

          ghcWith = if withHoogle
                      then hp.ghcWithHoogle
                      else hp.ghcWithPackages;

          basePackages = if withPackages
                           then [(ghcWith myHaskellPackages)]
                           else [];
      in super.buildEnv {
        name = name;
        paths = basePackages;
      };

    haskellTools = hp: with hp; [
      cabal2nix
      hindent
      hlint
      #ghc-mod
      #hdevtools
      ghc-core
      structured-haskell-mode
      hasktags
      pointfree
      cabal-install
      alex happy
    ];

    myHaskellPackages = hp: with hp; [
      # CC-delcont
      # arithmoi
      # compdata
      # errors
      # fixplate
      # linearscan
      # linearscan-hoopl
      # machines
      # orgmode-parse
      # pandoc
      # recursion-schemes
      # singletons
      # these
      # thyme
      # time-recurrence
      # timeparsers
      # units
      # folds
      Boolean
      HTTP
      HUnit
      MissingH
      QuickCheck
      SafeSemaphore
      aeson
      async
      attoparsec
      bifunctors
      blaze-builder
      blaze-builder-conduit
      blaze-builder-enumerator
      blaze-html
      blaze-markup
      blaze-textual
      cased
      cassava
      cereal
      comonad
      comonad-transformers
      dlist
      dlist-instances
      doctest
      exceptions
      fingertree
      foldl
      free
      hamlet
      hashable
      hspec
      hspec-expectations
      html
      http-client
      http-date
      http-types
      io-memoize
      keys
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
      mmorph
      monad-control
      monad-coroutine
      monad-loops
      monad-par
      monad-par-extras
      monad-stm
      monadloc
      mongoDB
      monoid-extras
      network
      newtype
      numbers
      optparse-applicative
      parsec
      parsers
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
      posix-paths
      postgresql-simple
      pretty-show
      profunctors
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
      spoon
      stm
      stm-chans
      stm-stats
      streaming
      streaming-bytestring
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
  };
}
