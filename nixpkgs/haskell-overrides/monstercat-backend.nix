{ Decimal
, MissingH
, aeson
, async
, attoparsec
, base
, bson
, bytestring
, conduit
, data-default
, failure
, fetchgitPrivate
, flexible
, flexible-instances
, ghc-prim
, hashable
, hashable-generics
, lens
, mkDerivation
, mongoDB
, mtl
, persistent
, persistent-mongoDB
, persistent-template
, pwstore-fast
, safe
, stdenv
, template-haskell
, text
, time
, transformers
, unordered-containers
, uuid
, vector
, word8
}:

with stdenv.lib;
mkDerivation rec {
  pname = "monstercat-backend";
  version = "1.1.0";

  # todo: get fetchgitPrivate working

  src = fetchgitPrivate {
    url = "ssh://git@phabricator.monstercat.com/diffusion/HBACK/haskell-backend";
    rev = "3e5ba112ca708e3ef036a26d03c632ee7507140e";
    sha256 = "306c7a985135011066cfcf6611bc5c7e7386e7900f218209f534083beaaff4ba";
  };

  # src = /dropbox/projects/monstercat/haskell/monstercat-backend;

  buildDepends = [
    Decimal
    MissingH
    aeson
    async
    attoparsec
    base
    bson
    bytestring
    conduit
    data-default
    failure
    flexible
    flexible-instances
    ghc-prim
    hashable
    lens
    mongoDB
    mtl
    persistent
    persistent-mongoDB
    persistent-template
    pwstore-fast
    safe
    template-haskell
    text
    time
    transformers
    unordered-containers
    uuid
    vector
    word8
  ];

  description = "Monstercat backend database";
  license = stdenv.lib.licenses.unfree;
}
