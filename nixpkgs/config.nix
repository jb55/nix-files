{ pkgs }:
let monstercatPkgs = import <monstercatpkgs> { inherit pkgs; };
    haskellOverrides = import ./haskell-overrides { inherit monstercatPkgs; };
    jb55pkgs = import <jb55pkgs> { inherit pkgs; };
    callPackage = pkgs.callPackage;
    doJailbreak = pkgs.haskell.lib.doJailbreak;
    dontCheck = pkgs.haskell.lib.dontCheck;
    regularFiles = builtins.filterSource (f: type: type == "symlink"
                                                || type == "directory"
                                                || type == "regular");
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
    enablePepperFlash = false; # Chromium's non-NSAPI alternative to Adobe Flash
  };

  packageOverrides = super: rec {
    # /run/current-system/sw/bin/ls $HOME/.emacs.d/elpa | sed 's/-[[:digit:]].*//g;s/\+$/-plus/g' | sort -u
    emacs = super.emacsWithPackages (ep: with ep; [
      pkgs.urweb
    ]);

    weechat = super.weechat.override {configure = {availablePlugins, ...}: {
        scripts = with super.weechatScripts; [ wee-slack ];
      };
    };

    bcalc = jb55pkgs.bcalc;

    # electrs = (import (pkgs.fetchFromGitHub {
    #   owner = "jb55";
    #   repo = "electrs";
    #   rev = "e3bed69c17dac1af1be34d18e5be2c815c20838c";
    #   sha256 = "0dqz872xiagpvk139xdfn46j5gn5njdk9qf50nq29x2flh81y1ya";
    # }) { inherit pkgs; }).rootCrate.build;

    lastpass-cli = super.lastpass-cli.override { guiSupport = true; };

    wine = super.wine.override { wineBuild = "wineWow"; };

    wineUnstable = super.wineUnstable.override { wineBuild = "wineWow"; };

    bluez = pkgs.bluez5;

    #nvidia_x11 = super.nvidia_x11_beta;

    # haskellPackages = super.haskellPackages.override {
    #   overrides = haskellOverrides pkgs;
    # };

    # xonsh = super.xonsh.override {
    #   extraPythonPackages = py: with py; [ numpy ];
    # };

    phonectl = super.python3Packages.callPackage (super.fetchFromGitHub {
      owner  = "jb55";
      repo   = "phonectl";
      sha256 = "0wqpwg32qa1rzpw7881r6q2zklxlq1y4qgyyy742pihfh99rkcmj";
      rev    = "de0f37a20d16a32a73f9267860302357b2df0c20";
    }) {};

    #jb55-dotfiles = regularFiles <dotfiles>;

    notmuch = pkgs.lib.overrideDerivation super.notmuch (attrs: {
      src = pkgs.fetchFromGitHub {
        owner  = "jb55";
        repo   = "notmuch";
        rev    = "adcc427b8356cca865479b433d4be362b1f50e38";
        sha256 = "14l95hld7gs42p890a9r8dfw4m945iy2sf9bdyajs2yqjwmarwn7";
      };

      doCheck = false;
    });

    wirelesstools =
      let
        patch = super.fetchurl {
                  url    = "https://jb55.com/s/iwlist-print-scanning-info-allocation-failed.patch";
                  sha256 = "31c97c6abf3f0073666f9f94f233fae2fcb8990aae5e7af1030af980745a8efc";
                };
      in
        pkgs.lib.overrideDerivation super.wirelesstools (attrs: {
          prePatch = ''
            patch -p0 < ${patch}
          '';
        });

    dmenu2 = pkgs.lib.overrideDerivation super.dmenu2 (attrs: {
      patches =
        [ (super.fetchurl
          { url = "https://jb55.com/s/404ad3952cc5ccf3.patch";
            sha1 = "404ad3952cc5ccf3aa0674f31a70ef0e446a8d49";
          })
        ];
    });

    htop = pkgs.lib.overrideDerivation super.htop (attrs: {
      patches =
        [ (super.fetchurl
          { url = "https://jb55.com/s/htop-vim.patch";
            sha256 = "3d72aa07d28d7988e91e8e4bc68d66804a4faeb40b93c7a695c97f7d04a55195";
          })

          (super.fetchurl
          { url = "https://jb55.com/s/0001-Improving-Command-display-sort.patch";
            sha256 = "2207dccce7f9de0c3c6f56d846d7e547c96f63c8a4659ef46ef90c3bd9a013d1";
          })
        ];
    });

    ical2org = super.callPackage ./scripts/ical2org { };

    footswitch = super.callPackage ./scripts/footswitch { };

    ds4ctl = super.callPackage ./scripts/ds4ctl { };

    haskellEnvHoogle = haskellEnvFun {
      name = "haskellEnvHoogle";
      #compiler = "ghc821";
      withHoogle = true;
    };

    haskellEnv = haskellEnvFun {
      name = "haskellEnv";
      #compiler = "ghc821";
      withHoogle = false;
    };

    haskell-tools = super.buildEnv {
      name = "haskell-tools";
      paths = haskellTools super.haskellPackages;
    };

    jb55-tools-env = pkgs.buildEnv {
      name = "jb55-tools";
      paths = with jb55pkgs; [
        csv-delim
        csv-scripts
        dbopen
        extname
        mandown
        snap
        sharefile
        samp
      ];
    };

    jvm-tools-env = pkgs.buildEnv {
      name = "jvm-tools";
      paths = with pkgs; [
        gradle
        maven
        oraclejdk
      ];
    };

    mk-rust-env = name: rustVer: pkgs.buildEnv {
      name = "rust-dev-${name}";
      paths = with pkgs; with rustVer; [
        clang
        rustracer
        rustracerd
        rust
        #cargo-edit
        #rustfmt
        rust-bindgen
      ];
    };

    rust-dev-env-nightly = mk-rust-env "nightly" pkgs.rustChannels.nightly;
    rust-dev-env-beta = mk-rust-env "beta" pkgs.rustChannels.beta;

    gaming-env = pkgs.buildEnv {
      name = "gaming";
      paths = with pkgs; [
        steam
      ];
    };

    file-tools = pkgs.buildEnv {
      name = "file-tools";
      paths = with pkgs; [
        ripgrep
        ranger
      ];
    };

    network-tools = pkgs.buildEnv {
      name = "network-tools";
      paths = with pkgs; with xorg; [
        nmap
        dnsutils
        whois
        nethogs
      ];
    };

    system-tools = pkgs.buildEnv {
      name = "system-tools";
      paths = with pkgs; with xorg; [
        xbacklight
        acpi
        psmisc
      ];
    };

    desktop-tools = pkgs.buildEnv {
      name = "desktop-tools";
      paths = with pkgs; with xorg; [
        twmn
        libnotify
      ];
    };

    syntax-tools = pkgs.buildEnv {
      name = "syntax-tools";
      paths = with pkgs; [
        shellcheck
      ];
    };

    mail-tools = pkgs.buildEnv {
      name = "mail-tools";
      paths = with pkgs; [
        notmuch
        msmtp
        muchsync
        isync
      ];
    };

    photo-env = pkgs.buildEnv {
      name = "photo-tools";
      paths = with pkgs; [
        gimp
        darktable
        rawtherapee
        ufraw
        dcraw
      ];
    };

    git-tools = pkgs.buildEnv {
      name = "git-tools";
      paths = with pkgs; [
        diffstat
        diffutils
        gist
        # git-lfs
        git-series
        gitAndTools.diff-so-fancy
        gitAndTools.git-imerge
        gitAndTools.git-extras
        gitAndTools.gitFull
        gitAndTools.hub
        gitAndTools.tig
        #haskPkgs.git-all
        #haskPkgs.git-monitor
        github-release
        patch
        patchutils
      ];
    };

    haskellEnvFun = { withHoogle ? false, compiler ? null, name }:
      let hp = if compiler != null
                 then super.haskell.packages.${compiler}
                 else super.haskellPackages;

          ghcWith = if withHoogle
                      then hp.ghcWithHoogle
                      else hp.ghcWithPackages;

      in super.buildEnv {
        name = name;
        paths = [(ghcWith myHaskellPackages)];
      };

    # stack2nix = import (pkgs.fetchFromGitHub {
    #   owner = "input-output-hk";
    #   repo  = "stack2nix";
    #   rev   = "6f59401c0e0ca3ab5e429b90e3c30de29a499db0";
    #   sha256 = "1ihcp3mr0s89xmc81f9hxq07jw6pm3lixr5bdamqiin1skpk8q3b";
    # }) { inherit pkgs; };

    haskellTools = hp: with hp; [
      alex
      cabal-install
      cabal2nix
      stack2nix
      hpack
      ghc-core
      happy
      (dontCheck hasktags)
      hindent
      hlint
      structured-haskell-mode
      haskell-ci
    ];

    myHaskellPackages = hp: with hp; [
      #(doJailbreak pandoc-lens)
      (dontCheck (doJailbreak serialise))
      Boolean
      Decimal
      HTTP
      HUnit
      MissingH
      QuickCheck
      SafeSemaphore
      aeson
      aeson-qq
      async
      attoparsec
      base32-bytestring
      base32string
      base58-bytestring
      bifunctors
      bitcoin-api
      bitcoin-api-extra
      bitcoin-block
      bitcoin-script
      bitcoin-tx
      blaze-builder
      blaze-builder-conduit
      blaze-html
      blaze-markup
      blaze-textual
      bson-lens
      #bytestring-show
      cased
      cassava
      cereal
      clientsession
      clientsession
      colour
      comonad
      comonad-transformers
      #compact-string-fix
      #cryptohash
      directory
      dlist
      dlist-instances
      doctest
      either
      elm-export
      elm-export-persistent
      exceptions
      filepath
      fingertree
      foldl
      formatting
      free
      generics-sop
      hamlet
      hashable
      hashids
      here
      heroku
      hedgehog
      hspec
      hspec-expectations
      html
      http-client
      http-date
      http-types
      inline-c
      io-memoize
      io-storage
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
      mbox
      mime-mail
      mime-types
      miso
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
      neat-interpolation
      network
      newtype
      numbers
      options
      optparse-applicative
      optparse-generic
      pandoc
      parsec
      parsers
      pcg-random
      persistent
      persistent-postgresql
      persistent-template
      posix-paths
      #postgresql-binary
      postgresql-simple
      pretty-show
      probability
      profunctors
      pwstore-fast
      quickcheck-instances
      random
      reducers
      reflection
      regex-applicative
      regex-base
      regex-compat
      regex-posix
      relational-record
      resourcet
      retry
      rex
      s3-signer
      safe
      sbv
      scotty
      sqlite-simple
      lucid
      semigroupoids
      semigroups
      #servant
      #servant-cassava
      #servant-client
      #servant-docs
      #servant-lucid
      #servant-server
      shake
      shakespeare
      #shelly
      shqq
      simple-reflect
      #speculation
      split
      spoon
      stache
      stm
      stm-chans
      #stm-stats
      store
      stache
      streaming
      smtp-mail
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
      text-regex-replace
      thyme
      time
      time-units
      #tinytemplate
      transformers
      transformers-base
      turtle
      unagi-chan
      uniplate
      unix-compat
      unordered-containers
      uuid
      vector
      void
      wai
      wai-middleware-static
      wai-extra
      warp
      wreq
      xhtml
      xml-lens
      yaml
      zippers
      zlib
    ];
  };
}
