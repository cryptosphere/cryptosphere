![Celluloid](https://github.com/tarcieri/cryptosphere/raw/master/logo.png)
================
[![Build Status](https://secure.travis-ci.org/tarcieri/cryptosphere.png?branch=master)](http://travis-ci.org/tarcieri/cryptosphere)

> "I want people to see the truth... regardless of who they are... because
> without information, you cannot make informed decisions as a public" _-- Bradley Manning_

The Cryptosphere is a global peer-to-peer cryptosystem for publishing and
securely distributing content anonymously with no central point of failure.
The system is openly federated and anyone can join. To ensure quality service
and prevent abuse, the Cryptosphere uses an integrated cryptographically
secure reputation system which provides a distributed web of trust.

There are several systems with similar goals to the Cryptosphere, such as
MNet, Freenet, and Tahoe-LAFS. These systems serve as inspiration for the
Cryptosphere's design. The Cryptosphere is also heavily influenced by Git, the
distributed version control system.

For more information, please see the [project philosophy][philosophy]
page in the wiki.

Like the Cryptosphere? [Join the Google Group][google group]
We're also on IRC at #cryptosphere on irc.freenode.net

[philosophy]:   https://github.com/tarcieri/cryptosphere/wiki/Philosophy
[google group]: https://groups.google.com/group/cryptosphere

### Is it any good?

[Yes.](http://news.ycombinator.com/item?id=3067434)

### Is It "Production Ready™"?

No, the Cryptosphere is still in an early development stage, and is not yet
ready for general usage.

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

Suggested Reading
-----------------

* [Tahoe - The Least-Authority Filesystem (Tahoe-LAFS)](http://www.laser.dist.unige.it/Repository/IPI-1011/FileSystems/TahoeDFS.pdf)
* [A Distributed Decentralized Information Storage and Retrieval System (Freenet)](http://freenetproject.org/papers/ddisrs.pdf)
* [Efficient Sharing of Encrypted Data (GNUnet)](http://grothoff.org/christian/esed.pdf)
* [Samsara: Honor Among Thieves in Peer-to-Peer Storage](http://www.eecs.harvard.edu/~mema/courses/cs264/papers/samsara-sosp2003.pdf)
* [The Sybil Attack](http://research.microsoft.com/pubs/74220/IPTPS2002.pdf)
* [A Sybilproof Indirect Reciprocity Mechanism for Peer-to-Peer Networks](http://discovery.ucl.ac.uk/14962/1/14962.pdf)
* [Incentive-driven QoS in peer-to-peer overlays](http://discovery.ucl.ac.uk/19490/1/19490.pdf)
* [Enforcing collaboration in peer-to-peer routing services](http://citeseerx.ist.psu.edu/images/pdf_icon.gif)

Contributing to the Cryptosphere
--------------------------------

* Fork this repository on github
* Make your changes and send me a pull request
* If I like them I'll merge them

License
-------

Copyright (c) 2012 Tony Arcieri. Distributed under the MIT License. See
LICENSE.txt for further details.
