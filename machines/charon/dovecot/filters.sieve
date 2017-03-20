
require ["body","fileinto","imap4flags","reject"];

if size :over 100K {
  reject text:
Sorry, this mailbox does not accept large attachments
over 100KB. Please share a Dropbox/Gdrive/etc link instead.

Cheers,
.
  ;
}

if allof (header :contains "from" "Microsoft Canada") {
	addflag "\\Seen";
}

if allof (header :contains "from" "post@tinyportal.net") {
	discard;
}

if allof (header :contains "from" "yahoo.com.hk") {
	discard;
}

# rule:[servers]
if allof (header :contains "from" "noreply@outbound.getsentry.com") {
	fileinto "Alerts";
}

# rule:[Haskell Streaming]
if allof (header :contains "list-id" "<streaming-haskell.googlegroups.com>") {
	fileinto "Lists.haskell";
}

# rule:[Haskell Pipes]
if allof (header :contains "list-id" "haskell-pipes.googlegroups.com") {
	fileinto "Lists.haskell";
}

# rule:[Nixpkgs]
if allof (header :contains "list-id" "nixpkgs.NixOS.github.com") {
	fileinto "Lists.nixpkgs";
}

# rule:[Haskell]
if allof (header :contains "list-id" "cabal-devel.haskell.org") {
	fileinto "Lists.haskell";
}

if allof (header :contains "list-id" "haskell-cafe.haskell.org") {
	fileinto "Lists.haskell";
}

if allof (header :contains "list-id" "ghc-devs.haskell.org") {
	fileinto "Lists.haskell";
}

# rule:[Haskell]
if allof (header :contains "list-id" "commercialhaskell.googlegroups.com") {
	fileinto "Lists.haskell";
}

# rule:[Haskell]
if allof (header :contains "list-id" "haskell.haskell.org") {
	fileinto "Lists.haskell";
}

# rule:[Alerts]
if allof (header :contains "from" "builds@circleci.com") {
	fileinto "Alerts";
}

# rule:[bitcoin-dev]
if allof (header :contains "list-id" "bitcoin-dev.lists.linuxfoundation.org") {
	fileinto "Lists.bitcoin";
}

# rule:[Monstercat]
if allof (header :contains "to" "bill@monstercat.com") {
	fileinto "Monstercat";
}

# rule:[Updates]
if allof (header :contains "from" "no-reply@twitch.tv") {
	fileinto "Updates";
}

# rule:[Meetup]
if allof (header :contains "from" "info@meetup.com") {
	fileinto "Updates";
}

# rule:[WebVR]
if allof (header :contains "list-id" "web-vr-discuss.mozilla.org") {
	fileinto "Lists.webvr";
}

# rule:[ICN]
if allof (header :contains "list-id" "ccnx.www.ccnx.org") {
	fileinto "Lists.icn";
}

# rule:[ICN]
if allof (header :contains "list-id" "icnrg.irtf.org") {
	fileinto "Lists.icn";
}

# rule:[ICN]
if allof (header :contains "list-id" "ccnx.ccnx.org") {
	fileinto "Lists.icn";
}

# rule:[elm-dev]
if allof (header :contains "list-id" "elm-dev@googlegroups.com") {
	fileinto "Lists.elm";
}

# rule:[Updates]
if allof (header :contains "from" "no-reply@mail.goodreads.com") {
	fileinto "Updates";
}

# Elm
if anyof ( header :contains "list-id" "elm-discuss@googlegroups.com"
         , address :is ["to", "cc"] "elm-discuss@googlegroups.com"
         )
{
	fileinto "Lists.elm";
}

if anyof ( header :contains "list-id"
             [ "nix-dev@lists.science.uu.nl"
             , "NixOS/nix <nix.NixOS.github.com>"
             , "NixOS/hydra <hydra.NixOS.github.com>"
             ]
         , address :is ["to", "cc"] 
             [ "nix-dev@lists.science.uu.nl"
             , "NixOS/nix <nix.NixOS.github.com>"
             , "NixOS/hydra <hydra.NixOS.github.com>"
             ]
         )
{
	fileinto "Lists.nix";
}

# rule:[Spacemacs]
if allof (header :contains "list-id" "syl20bnr/spacemacs <spacemacs.syl20bnr.github.com>") {
	fileinto "Lists.spacemacs";
}

# rule:[Updates]
if allof (header :contains "from" "gab.ai") {
	fileinto "Updates";
}

# rule:[haskell-commercial]
if allof (header :contains "list-id" "commercialhaskell@googlegroups.com") {
	fileinto "Lists.haskell";
}

if allof (header :contains "to" "mention@noreply.github.com") {
	addflag "\\Flagged";
}

if allof (header :contains "list-id" "ndn-interest@lists.cs.ucla.edu") {
	fileinto "Lists.ndn";
}

if allof (header :contains "list-id" "shake-build-system@googlegroups.com") {
	fileinto "Lists.haskell";
}

# rule:[ats]
if allof (header :contains "list-id" "ats-lang-users@googlegroups.com") {
	fileinto "Lists.ats";
}

# rule:[shen]
if allof (header :contains "list-id" "qilang@googlegroups.com") {
	fileinto "Lists.shen";
}

# rule:[Haskell Streaming]
if allof (header :contains "list-id" "michaelt/streaming <streaming.michaelt.github.com>") {
	fileinto "Lists.haskell";
}

# rule:[Craigslist]
if allof (header :contains "from" "reply.craigslist.org") {
	fileinto "Lists.craigslist";
}

# rule:[Alerts]
if allof (header :contains "from" "noreply@md.getsentry.com") {
	fileinto "Alerts";
}

# rule:[github]
if allof (header :contains "from" "notifications@github.com") {
	fileinto "GitHub";
}

