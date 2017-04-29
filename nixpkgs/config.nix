{ pkgs }:
let monstercatPkgs = import <monstercatpkgs> { inherit pkgs; };
    haskellOverrides = import ./haskell-overrides { inherit monstercatPkgs; };
    jb55pkgs = import <jb55pkgs> { nixpkgs = pkgs; };
    callPackage = pkgs.callPackage;
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
    enablePepperPDF = false;
  };

  packageOverrides = super: rec {
    # /run/current-system/sw/bin/ls $HOME/.emacs.d/elpa | sed 's/-[[:digit:]].*//g;s/\+$/-plus/g' | sort -u
    emacs = super.emacsWithPackages (ep: with ep; [
      ace-jump-helm-line
      ace-link
      ace-window
      ac-ispell
      adaptive-wrap
      aggressive-indent
      alert
      anaconda-mode
      anzu
      async
      auctex
      auto-compile
      auto-complete
      auto-highlight-symbol
      auto-yasnippet
      avy
      base16-theme
      bind-key
      bind-map
      cargo
      clang-format
      clean-aindent-mode
      #cmake-mode
      cmm-mode
      coffee-mode
      column-enforce-mode
      company
      company-anaconda
      company-auctex
      company-cabal
      company-c-headers
      company-emacs-eclim
      company-emoji
      company-ghc
      company-ghci
      company-irony
      company-nixos-options
      company-quickhelp
      company-statistics
      company-tern
      csharp-mode
      csv-mode
      cython-mode
      dash
      dash-functional
      define-word
      diminish
      disaster
      dumb-jump
      eclim
      elisp-slime-nav
      elm-mode
      emoji-cheat-sheet-plus
      emojify
      engine-mode
      ensime
      epl
      ereader
      eval-sexp-fu
      evil
      evil-anzu
      evil-args
      evil-ediff
      evil-escape
      evil-exchange
      evil-iedit-state
      evil-indent-plus
      evil-lisp-state
      evil-magit
      evil-matchit
      evil-mc
      evil-nerd-commenter
      evil-numbers
      evil-search-highlight-persist
      evil-surround
      evil-tutor
      #evil-unimpaired
      evil-visual-mark-mode
      evil-visualstar
      expand-region
      eyebrowse
      f
      faceup
      fancy-battery
      fill-column-indicator
      flx
      flx-ido
      flycheck
      flycheck-elm
      flycheck-haskell
      flycheck-ledger
      flycheck-pos-tip
      flycheck-rust
      #fsharp-mode
      fuzzy
      ggtags
      ghc
      gh-md
      gitattributes-mode
      git-commit
      gitconfig-mode
      gitignore-mode
      git-link
      git-messenger
      git-timemachine
      glsl-mode
      gntp
      #gnupg
      gnuplot
      golden-ratio
      google-translate
      goto-chg
      gradle-mode
      groovy-imports
      groovy-mode
      haskell-mode
      haskell-snippets
      helm
      helm-ag
      helm-company
      helm-core
      helm-c-yasnippet
      helm-descbinds
      helm-flx
      helm-gitignore
      helm-gtags
      helm-hoogle
      helm-make
      helm-mode-manager
      helm-nixos-options
      helm-pages
      helm-projectile
      helm-purpose
      helm-pydoc
      helm-spotify
      helm-swoop
      helm-themes
      help-fns-plus
      hide-comnt
      highlight
      highlight-indentation
      highlight-numbers
      highlight-parentheses
      hindent
      hlint-refactor
      hl-todo
      ht
      htmlize
      hungry-delete
      hydra
      hy-mode
      idris-mode
      iedit
      imenu-list
      indent-guide
      info-plus
      intero
      irony
      jade-mode
      js2-mode
      js2-refactor
      js-doc
      json-mode
      json-reformat
      json-snatcher
      ledger-mode
      #link-hint
      linum-relative
      live-py-mode
      livid-mode
      log4e
      lorem-ipsum
      lua-mode
      macrostep
      magit
      magit-gitflow
      magit-popup
      markdown-mode
      markdown-toc
      #mastodon
      meghanada
      mmm-mode
      move-text
      multi
      multiple-cursors
      neotree
      nix-mode
      nixos-options
      notmuch
      omnisharp
      open-junk-file
      org-brain
      org-download
      orgit
      org-plus-contrib
      org-pomodoro
      org-present
      org-projectile
      packed
      paradox
      parent-mode
      pcache
      pcre2el
      persp-mode
      pip-requirements
      pkg-info
      popup
      popwin
      pos-tip
      powerline
      #powershell
      projectile
      prop-menu
      psci
      psc-ide
      purescript-mode
      pyenv-mode
      py-isort
      pytest
      pythonic
      pyvenv
      racer
      racket-mode
      rainbow-delimiters
      request
      restart-emacs
      rust-mode
      s
      sbt-mode
      scala-mode
      seq
      shen-elisp
      simple-httpd
      skewer-mode
      smartparens
      smeargle
      spaceline
      spinner
      spotify
      sql-indent
      string-inflection
      symon
      tern
      tide
      toc-org
      toml-mode
      tracking
      typescript-mode
      undo-tree
      use-package
      uuidgen
      vi-tilde-fringe
      volatile-highlights
      web-beautify
      weechat
      which-key
      window-purpose
      winum
      with-editor
      ws-butler
      xml-plus
      yaml-mode
      yapfify
      yasnippet
    ]);

    bluez = pkgs.bluez5;

    # qt4 = pkgs.qt48Full.override { gtkStyle = true; };

    haskellPackages = super.haskellPackages.override {
      overrides = haskellOverrides pkgs;
    };

    pidgin-with-plugins = super.pidgin-with-plugins.override {
      plugins = (with super; [ purple-hangouts pidginotr pidginwindowmerge pidgin-skypeweb pidgin-opensteamworks ]);
    };

    jb55-dotfiles = regularFiles <dotfiles>;

    ical2org = super.callPackage ./scripts/ical2org { };

    footswitch = super.callPackage ./scripts/footswitch { };

    ds4ctl = super.callPackage ./scripts/ds4ctl { };

    haskellEnvHoogle = haskellEnvFun {
      name = "haskellEnvHoogle";
      withHoogle = true;
    };

    haskellEnv = haskellEnvFun {
      name = "haskellEnv";
      withHoogle = false;
    };

    haskell-tools-env = super.buildEnv {
      name = "haskell-tools";
      paths = haskellTools haskellPackages;
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
        cargo-edit
        rustfmt
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

    git-tools-env = pkgs.buildEnv {
      name = "git-tools";
      paths = with pkgs; [
        diffstat
        diffutils
        gist
        # git-lfs
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
      # binary-serialise-cbor
      alex
      cabal-install
      cabal2nix
      ghc-core
      ghc-mod
      happy
      hasktags
      hindent
      hlint
      # pointfree
      structured-haskell-mode
      super.multi-ghc-travis
    ];

    myHaskellPackages = hp: with hp; [
      aeson
      # aeson-applicative
      aeson-qq
      amazonka
      amazonka-s3
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
      # blaze-builder-enumerator
      blaze-html
      blaze-markup
      blaze-textual
      Boolean
      # bound
      bson-lens
      cased
      cassava
      cereal
      comonad
      comonad-transformers
      compact-string-fix
      directory
      dlist
      dlist-instances
      doctest
      either
      elm-export
      # envy
      exceptions
      failure
      filepath
      fingertree
      foldl
      formatting
      free
      generics-sop
      gogol
      gogol-core
      gogol-sheets
      gogol-youtube
      gtk
      hamlet
      hashable
      heroku
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
      # language-bash
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
      mongoDB
      monoid-extras
      # monstercat-backend
      network
      newtype
      numbers
      options
      optparse-applicative
      parsec
      parsers
      pcg-random
      persistent
      #persistent-mongoDB
      persistent-postgresql
      persistent-template
      pipes
      # pipes-async
      pipes-attoparsec
      # pipes-binary
      pipes-bytestring
      pipes-concurrency
      pipes-csv
      pipes-extras
      pipes-group
      pipes-http
      pipes-mongodb
      pipes-network
      pipes-parse
      pipes-postgresql-simple
      pipes-safe
      # pipes-shell
      pipes-text
      pipes-wai
      posix-paths
      postgresql-binary
      postgresql-simple
      # postgresql-simple-sop
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
      # regular
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
      servant
      servant-cassava
      servant-client
      servant-docs
      # servant-elm
      servant-lucid
      servant-server
      # servant-swagger
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
      # time-patterns
      time-units
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
      xml-lens
      yaml
      zippers
      zlib
    ];
  };
}
