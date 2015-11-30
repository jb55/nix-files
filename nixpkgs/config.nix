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
      paths = haskellTools super.haskellPackages;
    };

    haskellEnvFun = { withHoogle ? false, withPackages ? true, compiler ? null, name }:
      let hp = if compiler != null
                 then super.haskell.packages.${compiler}
                 else super.haskellPackages;

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

    syntaxCheckersEnv = super.buildEnv {
      name = "syntaxCheckers";
      paths = [
        pkgs.haskellPackages.ShellCheck
      ];
    };

    machineLearningToolsEnv = super.buildEnv {
      name = "machineLearningTools";
      paths = with super; [
        caffe
      ];
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
      # fixplate
      # orgmode-parse
      Boolean
      # CC-delcont
      HTTP
      HUnit
      MissingH
      QuickCheck
      aeson
      # arithmoi
      async
      attoparsec
      bifunctors
      blaze-builder
      blaze-builder-conduit
      blaze-builder-enumerator
      blaze-html
      blaze-markup
      blaze-textual
      cassava
      cased
      cereal
      comonad
      comonad-transformers
      # compdata
      dlist
      dlist-instances
      doctest
      # errors
      exceptions
      fingertree
      foldl
      #folds
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
      # linearscan
      # linearscan-hoopl
      list-extras
      list-t
      logict
      # machines
      mime-mail
      mime-types
      mmorph
      mongoDB
      monad-control
      monad-coroutine
      monad-loops
      monad-par
      monad-par-extras
      monad-stm
      monadloc
      monoid-extras
      network
      newtype
      numbers
      optparse-applicative
      # pandoc
      parsec
      parsers
      persistent
      persistent-template
      persistent-mongoDB
      pipes
      pipes-async
      pipes-attoparsec
      pipes-binary
      pipes-bytestring
      pipes-concurrency
      pipes-csv
      pipes-mongodb
      pipes-extras
      pipes-group
      pipes-http
      pipes-network
      pipes-parse
      pipes-safe
      pipes-shell
      pipes-text
      posix-paths
      #postgresql-simple
      pretty-show
      profunctors
      random
      # recursion-schemes
      reducers
      reflection
      regex-applicative
      regex-base
      regex-compat
      regex-posix
      regular
      resourcet
      retry
      rex
      SafeSemaphore
      safe
      sbv
      scotty
      semigroupoids
      semigroups
      shake
      shakespeare
      shelly
      simple-reflect
      # singletons
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
      tar
      tardis
      tinytemplate
      test-framework
      test-framework-hunit
      taggy
      taggy-lens
      tasty
      tasty-hspec
      tasty-hunit
      tasty-quickcheck
      tasty-smallcheck
      temporary
      text
      text-format
      # these
      # thyme
      time
      # time-recurrence
      # timeparsers
      transformers
      transformers-base
      turtle
      uniplate
      # units
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
