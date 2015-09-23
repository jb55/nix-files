{ pkgs }:
{
  allowUnfree = true;
  allowBroken = false;
  zathura.useMupdf = true;

  packageOverrides = super: rec {
    haskell = super.haskell // {
      packages = super.haskell.packages // {
        ghc784 = super.haskell.packages.ghc784.override {
          overrides = self: super: {
            mongoDB = super.mongoDB.overrideDerivation (attrs: {
              src = pkgs.fetchFromGitHub {
                owner = "mongodb-haskell";
                repo = "mongodb";
                rev = "cb912cb952542a6d60cfc31ee2ef2f41d41eefff";
                sha256 = "1nv1mffbkq90g6657gp2sb2sf6q5l44yxjn20haaym9nh1xkzfrz";
              };
            });
          };
        };
      };
    };

    haskellPackages = super.haskellPackages.override {
      overrides = self: super: {
        "ghc-mod" = super."ghc-mod".overrideDerivation (attrs: {
          src = pkgs.fetchFromGitHub {
            owner = "kazu-yamamoto";
            repo = "ghc-mod";
            rev = "edfce196107dbd43958d72c174ad66e4a7d30643";
            sha256 = "1wiwkp4qcgdwnr4h1bn27hh1kyl2wjlrz2bbfv638y9gzc06rgch";
          };
          nativeBuildInputs = [ super."cabal-helper" super.cereal super.pipes ] ++ attrs.nativeBuildInputs;
          postInstall = "";
        });

        "cabal-helper" = super."cabal-helper".overrideDerivation (attrs: {
          src = pkgs.fetchFromGitHub {
            owner = "DanielG";
            repo = "cabal-helper";
            rev = "3484965e347f39e976e0e850a5620354dbffabfc";
            sha256 = "0qi230hsyp5pamak2gk5kviiar7g35wd7wdkg8zz1hsjbjy5iwbn";
          };
        });

      };
    };

    haskellEnvHoogle = haskellEnvFun {
      name = "haskellEnvHoogle";
      withHoogle = true;
    };

    haskellEnv = haskellEnvFun {
      name = "haskellEnv";
      withHoogle = false;
    };

    haskellToolsEnv = haskellEnvFun {
      name = "haskellTools";
      withPackages = false;
    };

    haskellEnvFun = { tools ? haskellTools, withHoogle ? false, withPackages ? true, compiler ? null, name }:
      let hp = if compiler != null
                 then super.haskell.packages.${compiler}
                 else super.haskellPackages;

          ghcWith = if withHoogle
                      then hp.ghcWithHoogle
                      else hp.ghcWithPackages;

          basePackages = if withPackages
                           then ghcWith myHaskellPackages
                           else [];
      in super.buildEnv {
        name = name;
        paths = [basePackages (tools hp)];
      };

    syntaxCheckersEnv = super.buildEnv {
      name = "syntaxCheckers";
      paths = [
        haskellPackages.ShellCheck
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
      ghc-mod
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
