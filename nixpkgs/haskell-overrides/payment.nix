{ mkDerivation
, Decimal
, MissingH
, QuickCheck
, aeson
, aeson-pretty
, ansi-wl-pprint
, async
, attoparsec
, base
, bytestring
, cased
, cassava
, data-default
, directory
, errors
, envy
, fetchFromGitHub
, fetchgitPrivate
, filepath
, flexible
, flexible-instances
, foldl
, formatting
, hashable
, haskellPackages
, keys
, lens
, lens-aeson
, lifted-base
, money
, monstercat-backend
, mtl
, options
, parsec
, pipes
, pipes-bytestring
, pipes-csv
, pipes-safe
, random
, safe
, stdenv
, syb
, split
, text
, time
, transformers
, unordered-containers
, uuid
, yaml
}:
mkDerivation {
  pname = "payment";
  version = "0.1.2";
  src = /dropbox/projects/monstercat/haskell/massager;
  buildDepends = [
    Decimal
    MissingH
    QuickCheck
    aeson
    aeson-pretty
    ansi-wl-pprint
    async
    attoparsec
    base
    bytestring
    cased
    cassava
    data-default
    directory
    errors
    envy
    filepath
    formatting
    split
    flexible
    flexible-instances
    foldl
    hashable
    keys
    lens
    lens-aeson
    lifted-base
    money
    monstercat-backend
    mtl
    options
    parsec
    pipes
    pipes-bytestring
    pipes-csv
    pipes-safe
    random
    safe
    syb
    text
    time
    transformers
    unordered-containers
    uuid
    yaml
  ];
  license = stdenv.lib.licenses.bsd3;
}
