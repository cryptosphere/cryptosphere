![Celluloid](https://github.com/cryptosphere/cryptosphere/raw/master/images/logo.png)
================
[![Build Status](https://secure.travis-ci.org/tarcieri/cryptosphere.png?branch=master)](http://travis-ci.org/tarcieri/cryptosphere)
[![Code Climate](https://codeclimate.com/github/cryptosphere/cryptosphere.png)](https://codeclimate.com/github/cryptosphere/cryptosphere)
[![Coverage Status](https://coveralls.io/repos/cryptosphere/cryptosphere/badge.png?branch=master)](https://coveralls.io/r/cryptosphere/cryptosphere)

> "I want people to see the truth... regardless of who they are... because
> without information, you cannot make informed decisions as a public" _-- Chelsea Elizabeth Manning_

The Cryptosphere is a global peer-to-peer cryptosystem for publishing and
securely distributing content pseudonymously with no central point of failure.
The system is openly federated and anyone can join. To ensure quality service
and prevent abuse, the Cryptosphere uses an integrated cryptographically
secure reputation system which provides a distributed web of trust.

There are several systems with similar goals to the Cryptosphere, such as
MNet, Freenet, and Tahoe-LAFS. These systems serve as inspiration for the
Cryptosphere's design. The Cryptosphere is also heavily influenced by Git, the
distributed version control system.

For more information, please see the [project philosophy][philosophy]
page in the wiki.

---

Like the Cryptosphere? [Join the Google Group][google group]. To join by e-mail,
send a message to: [cryptosphere+subscribe@googlegroups.com][subscribe]

We're also on IRC at #cryptosphere on irc.freenode.net

[philosophy]:   https://github.com/cryptosphere/cryptosphere/wiki/Philosophy
[google group]: https://groups.google.com/group/cryptosphere
[subscribe]:    mailto:cryptosphere+subscribe@googlegroups.com

### Is it any good?

[Yes.](http://news.ycombinator.com/item?id=3067434)

### Is it "Production Ready™"?

![DANGER: EXPERIMENTAL](https://raw.github.com/cryptosphere/cryptosphere/master/images/experimental.png)

No, the Cryptosphere is still in an early development stage, and is not yet
ready for general usage.

### Can I use it yet?

No, but the system is being actively developed. You can view progress here:

* [Cryptosphere Trello Board](https://trello.com/b/WMKsvLOW/cryptosphere)

### Is there at least something I can play with?

You can see the system's work-in-progress UI if you'd like.

First, make sure that [libsodium](https://github.com/libsodium/libsodium) is available.
For OS X, it is available via Homebrew: `brew install libsodium`. On other systems, follow
the [installation instructions](https://github.com/jedisct1/libsodium#installation).

Then run the following to clone the repo from Github and set up a local copy.

```
git clone https://github.com/cryptosphere/cryptosphere.git
cd cryptosphere
bundle
bundle exec bin/crypt server
```

This will launch a local web server:

```
$ bundle exec bin/crypt server
I, [2012-11-30T21:23:30.059083 #62043]  INFO -- : Starting web UI on http://127.0.0.1:7890
```

You can view the web UI at `http://127.0.0.1:7890`

Documentation
-------------
[The Cryptosphere Wiki](https://github.com/cryptosphere/cryptosphere/wiki)
contains all relevant documentation, including the protocol specification, FAQ,
and usage notes.

Use Cases
---------

The Cryptosphere provides an encrypted storage system where only users with
the capability tokens for respective content are able to access it. Unlike
many other peer to systems, there is no global search system because all
content in the system is encrypted and therefore unsearchable.

This makes the Cryptosphere quite a bit different from many other P2P systems
which sought to publicize users content. Instead, the Cryptosphere tries to
keep your content as confidential as possible. This makes it useful for the
following things:

* Secure personal backups
* File sharing among small groups (ala Dropbox)
* Secure anonymous encrypted source control
* Censorship-proof anonymous web hosting

Important Questions
-------------------

### Is it "Military Grade™"?

Only if your military understands twisted Edwards curves

### Is it NSA-proof?

Like, totally

### Does it have a lock with a checkmark?

Sure, here you go:

![Checkmarked Lock](http://i.imgur.com/dwA0Ffi.png)

### No really, I'm interested in the system's cryptography. What should I read?

We realize there's a lot of people making ["interesting" claims][lolclaims] in
the security world, and that claims alone don't work. We need well-designed,
well-documented, well-scrutinized open source cryptosystems.

Check out the [Data Model][data_model] page in the Wiki for the threat model and
a specification of the cryptography employed in the system. It's still a work
in progress and some components of the system aren't specified yet.
We're going with a specify-then-implement approach, so by all means
provide feedback on the design, we'd love it.

The [Protocol][protocol] page of the Wiki describes the transport encryption we
use (CurveCP) and our rationale for this choice.

Cryptographic primitives are supplied by [RbNaCl][rbnacl], a Ruby binding to
the [Networking and Cryptography (NaCl)][nacl] library by Daniel J. Bernstein.
The Cryptosphere uses a portable repackaging of NaCl named
[libsodium][libsodium].

[lolclaims]: http://unsene.com/blog/2013/06/15/is-most-encryption-broken/#awesm=8fa4f90ed0755accf0cf65b4915d1214
[data_model]: https://github.com/cryptosphere/cryptosphere/wiki/Data-Model
[protocol]: https://github.com/cryptosphere/cryptosphere/wiki/Protocol
[rbnacl]: https://github.com/cryptosphere/rbnacl
[nacl]: http://nacl.cr.yp.to/
[libsodium]: https://github.com/jedisct1/libsodium

### Have any fancy pants cryptographers taken a look at the design?

Matt Green glanced over an initial draft of the data model. He thought that
Blake2bXSalsa20Poly1305 was a funny name.

Contributing to the Cryptosphere
--------------------------------

* Fork this repository on github
* Make your changes and send us a pull request
* If we like them we'll merge them

License
-------

Copyright (c) 2013 Tony Arcieri. Distributed under the MIT License. See
LICENSE.txt for further details.

---

> Dedicated to the memory of Iain Banks
