
require ["regex", "variables","envelope","mailbox","body","fileinto","imap4flags","reject"];

if allof (header :contains "from" "Microsoft Canada") {
	addflag "\\Seen";
}

if header :contains "X-RSS-Feed" "reddit.com" {
  fileinto "Reddit";
}
elsif header :contains "X-RSS-Feed" "arxiv.org" {
  fileinto "Arxiv";
}
elsif header :contains "X-RSS-Feed" "youtube.com" {
  fileinto "YouTube";
}
elsif header :contains "X-RSS-Feed" "ycombinator.com" {
  fileinto "HackerNews";
}
elsif header :contains "from" "user@rss2email.invalid"  {
  fileinto "RSS";
}

if header :contains "list-id" "lobsters-izs7WbyfQp@lobste.rs" {
  fileinto "Lists.lobsters";
}

if header :contains "list-id" "emacs-devel.gnu.org" {
  fileinto "Lists.emacs";
}

if header :contains "list-id" "guix-devel.gnu.org" {
  fileinto "Lists.guix";
}

if header :contains "to" "cryptography@metzdowd.com" {
  fileinto "Lists";
}

if header :contains "user-agent" "rss2email" {
  fileinto "RSS";
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
if header :contains "list-id"
  [ "streaming-haskell.googlegroups.com"
  , "cabal-devel.haskell.org"
  , "commercialhaskell.googlegroups.com"
  , "ghc-devs.haskell.org"
  , "haskell-cafe.haskell.org"
  , "haskell.haskell.org"
  , "libraries.haskell.org"
  , "haskell-pipes.googlegroups.com"
  , "shake-build-system.googlegroups.com"
  ]
{
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
if header :contains "from" [ "no-reply@twitch.tv"
                           , "notify@twitter.com"
                           , "info@meetup.com"
                           , "no-reply@mail.goodreads.com"
                           ]
{
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

# Elm
if header :contains "list-id" [ "elm-discuss", "elm-dev" ] {
	fileinto "Lists.elm";
}

# GitHub
if header :contains "list-id"
     [ "nix.NixOS.github.com"
     , "hydra.NixOS.github.com"
     , "nix-dev.lists.science.uu.nl"
     ]
{
	fileinto "Lists.nix";
}
elsif header :contains "list-id" "spacemacs.syl20bnr.github.com" {
	fileinto "Lists.spacemacs";
}
elsif header :contains "list-id" "streaming.michaelt.github.com" {
	fileinto "Lists.haskell";
}
elsif header :contains "list-id" "nixpkgs.NixOS.github.com" {
	fileinto "Lists.nixpkgs";
}
elsif header :contains "from" "notifications@github.com" {
  # file into github if it doesn't match any other github lists
	fileinto "GitHub";
}

# rule:[Updates]
if header :contains "from" "gab.ai" {
	fileinto "Updates";
}

if header :contains "to" "mention@noreply.github.com" {
	addflag "\\Flagged";
}

if header :contains "list-id" "ndn-interest.lists.cs.ucla.edu" {
	fileinto "Lists.icn";
}

# rule:[ats]
if allof (header :contains "list-id" "ats-lang-users.googlegroups.com") {
	fileinto "Lists.ats";
}

# rule:[shen]
if allof (header :contains "list-id" "qilang.googlegroups.com") {
	fileinto "Lists.shen";
}


# rule:[Craigslist]
if allof (header :contains "from" "reply.craigslist.org") {
	fileinto "Lists.craigslist";
}


# split out the various list forms
# Mailman & other lists using list-id
if exists "list-id" {
    if header :regex "list-id" "<([a-z_0-9-]+)[.@]" {
        set :lower "listname" "${1}";
        fileinto :create "${listname}";
    } else {
        if header :regex "list-id" "^\\s*<?([a-z_0-9-]+)[.@]" {
            set :lower "listname" "${1}";
            fileinto :create "${listname}";
        } else {
            keep;
        }
    }
    stop;}
# Listar and mailman like
elsif exists "x-list-id" {
    if header :regex "x-list-id" "<([a-z_0-9-]+)\\\\." {
        set :lower "listname" "${1}";
        fileinto :create "${listname}";
    } else {
        keep;
    }
    stop;}
# Ezmlm
elsif exists "mailing-list" {
    if header :regex "mailing-list" "([a-z_0-9-]+)@" {
        set :lower "listname" "${1}";
        fileinto :create "${listname}";
    } else {
        keep;
    }
    stop;}
# York lists service
elsif exists "x-mailing-list" {
    if header :regex "x-mailing-list" "^\\s*([a-z_0-9-]+)@?" {
        set :lower "listname" "${1}";
        fileinto :create "${listname}";
    } else {
        keep;
    }
    stop;}
# Smartlist
elsif exists "x-loop" {
	if header :regex "x-loop" "^\\s*(a-z_0-9-]+)@?" {
		set :lower "listname" "${1}";
		fileinto :create "${listname}";
	} else {
	    keep;
	}
    stop;}
# poorly identified
elsif envelope :contains "from" "owner-" {
    if envelope :regex "from" "owner-([a-z_0-9-]+)-outgoing@" {
        set :lower "listname" "${1}";
        fileinto :create "${listname}";
    } elsif envelope :regex "from" "owner-([a-z_0-9-]+)@" {
        set :lower "listname" "${1}";
        fileinto :create "${listname}";
    } elsif header :regex "Sender" "owner-([a-z_0-9-]+)@" {
        set :lower "listname" "${1}";
        fileinto :create "${listname}";
    } else {
        keep;
    }
    stop;}
# other poorly identified
elsif  envelope :contains "from" "-request" {
    if envelope :regex "from" "([a-z_0-9-]+)-request@" {
        set :lower "listname" "${1}";
        fileinto :create "${listname}";
    } else {
        keep;
    }
    stop;
}


# rule:[Alerts]
if allof (header :contains "from" "noreply@md.getsentry.com") {
	fileinto "Alerts";
}

