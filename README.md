The Cryptosphere
================
[![Build Status](http://travis-ci.org/tarcieri/cryptosphere.png)](http://travis-ci.org/tarcieri/cryptosphere)

> "I want people to see the truth... regardless of who they are... because
> without information, you cannot make informed decisions as a public"  
> _-- Bradley Manning_

The Cryptosphere is a global peer-to-peer cryptosystem for publishing and
securely distributing content anonymously with no central point of failure.
The system is openly federated and anyone can join. To ensure quality service
and prevent abuse, the Cryptosphere uses an integrated cryptographically
secure reputation system which provides a distributed web of trust.

There are several systems with similar goals to the Cryptosphere, such as
MNet, Freenet, and Tahoe-LAFS. These systems serve as inspiration for the
Cryptosphere's design. The Cryptosphere is also heavily influenced by Git, the
distributed version control system.

What makes the Cryptosphere different?
--------------------------------------

Many have sought to build an openly federated data storage system. Such a
system was the basis for MojoNation, a startup which let you sell your
storage and bandwidth for a virtual currency called Mojo. Unfortunately
MojoNation never took off.

Freenet is the most similar system to the Cryptosphere today. Freenet
provides strong guarantees on anonymity and seeks to provide a low barrier
of entry for publishing content on the system.

The Cryptosphere strikes a balance between these two systems. Instead of using
any sort of virtual currency like Mojo, peers barter with each other in
exchanges which are completely localized to the peers involved. However, while
every peer in a cryptographic exchange keeps extensive, cryptographically
signed records of what was exchanged (or what they attempted to exchange),
the specifics of what data was exchanged are not stored in the records, nor
can they be derived from decrypting the content.

However, in a direct peer-to-peer exchange the Cryptosphere does nothing to
mask the transactions a particular is performing, as opposed to systems like
Freenet and Tor which make an effort to obscure which host you're actually
talking to by routing them through a chain of proxies. In this regard the
anonymity guarantees of the Cryptosphere are no different from a system like
BitTorrent, aside from the plausible deniability defense that comes from the
fact all content is encrpyted and peers automatically provide storage service
to other peers.

Instead, the Cryptosphere favors system robustness over guarantees on
anonymity. Participants in the system maintain a history of their activities
in the form of a long-chain certificate. You can think of this being somewhat
like the BitCoin block chain, where the longest version always wins, and its
integrity can be cryptographically verified. Every peer maintains its own long
chain certificate of all its activities, including services requested and
services completed.

Rather than verifying the integrity of a long chain based on hashes, the
Cryptosphere uses public key cryptography. Peers requesting services sign off
on both the request and delivery of a service (e.g. storing and serving a
particular chunk of a file). While in isolation the data points contained
within a particular long chain certificate are meaningless, peers can
collect several of these certificates and build a database of other peers
in the system, using tools like collaborative filtering to make intelligent
decisions about which other peers are worth interacting with.

Greed, Altruism, and Reciprocity
--------------------------------

The Cryptosphere's trust model works to limit greed. Storage space and
bandwidth are viewed as fungible commodities which come at a cost to the
provider. Greedy peers want to consume these resources without contributing
back to the system, ignoring the cost of the resources to those who provide
it. There are two ways that greedy peers can abuse the system:

1. Storage: greedy peers will seek to fill the system with objects only they
   are interested in

2. Bandwidth: greedy peers will consume content from the system without
   contributing bandwidth in return

The Cryptosphere prevents greed by encouraging reciprocity through a sort of
bartering system: storage is traded for storage and bandwidth, and bandwidth
is traded for bandwidth. Peers select the best trading partners based on their
own self-interest and all available data, then engage in trades. Trades with
newcomers are initially considered risky, but have the potential to grow into
a potentially fruitful relationship.

Storage is negotiated in units called "creds" which equate to storing a single
byte for one day (86400 seconds). At the end of the day peers can determine if
the exchange was mutually beneficial and decide to renegotiate it for another
day. Peers will avoid renegotiating with other peers that did not faithfully
provide a service. The goal is for peers to eventually form long-term, ongoing
relationships of storing particular pieces of data to ensure it remains highly
available.

By default the Cryptosphere software is tuned to be a somewhat altruistic risk
taker in the interests of making the Cryptosphere as a whole a more useful and
robust system. In the future it should be possible to tune the Cryptosphere
to your needs as an individual peer, being as altruistic or stingy as you like.
Altruistic peers will improve system robustness at the expense of being an
easy target for greedy peers. Stingy peers will be difficult to trade with and
will favor established members of the community with a good reputation among
a large body of peers that the stingy peer knows directly.

How the Cryptosphere stores data
--------------------------------

As you might expect from the name, everything within the Cryptosphere is 
encrypted using strong cryptography, in the form of public key ciphers,
block ciphers, or hash functions. This includes every single packet used
throughout the system (including the handshake!), and all data stored
within the system.

Data is stored using a technique called convergent encryption. Convergent
encryption means that when a file is encrypted, you will always get the same
cryptographic result, allowing files to be deduplicated globally. This
approach works by calculating a hash (specifically a SHA256 hash) of a file's
contents and using that as the key for a block cipher (specifically AES256).

The Cryptosphere identifies values by the hash of the *encrypted* contents,
meaning to get the plaintext for a particular file you must know two hashes:
the hash of the encrypted file (in order to ask the peer network to download
the file) and the original hash of the file's plaintext contents (in order to
have the AES256 key to decrypt it)

Because of this, the act of transferring a file or parts of files from other
peers does not mean you have access to the plaintext. This means that users of
the software have plausible deniability that by transferring the ciphertext of
the content they have access to the plaintext. The system by its very nature
works to increase the redundancy of data within the system in a distributed
manner, and content may be transferred to a particular user's computer without
the user of the software's knowledge or consent. 

This makes it difficult to prove that a particular user was deliberately trying
to access any specific piece of content on the system. Unless you can prove they
have the original hash of any file you cannot establish they even have access to
the contents, only to the ciphertext, and therefore logs of specific IP
addresses transferring encrypted data prove nothing as the software by design may
transfer parts of files between peers at any time. You cannot prove the user
elected to engage in the transfer, and even if you could, unless you can prove
the encryption key needed to access a particular piece of content is present on
a particular user's computer (and that a particular person chose to obtain that
encryption key) you cannot prove they actually voluntarily elected to acquire
a particular piece of content.

Suggested Reading
-----------------

The Cryptosphere is based on a number of previous, similar P2P cryptosystems.
Here are the papers for some of the software's influences:

* [Tahoe - The Least-Authority Filesystem (Tahoe-LAFS)](https://tahoe-lafs.org/~zooko/lafs.pdf)
* [A Distributed Decentralized Information Storage and Retrieval System (Freenet)](http://freenetproject.org/papers/ddisrs.pdf)
* [Efficient Sharing of Encrypted Data (GNUnet)](http://grothoff.org/christian/esed.pdf)
* [Samsara: Honor Among Thieves in Peer-to-Peer Storage](http://www.eecs.harvard.edu/~mema/courses/cs264/papers/samsara-sosp2003.pdf)
* [A Sybilproof Indirect Reciprocity Mechanism for Peer-to-Peer Networks](http://discovery.ucl.ac.uk/14962/1/14962.pdf)
* [Incentive-driven QoS in peer-to-peer overlays](http://discovery.ucl.ac.uk/19490/1/19490.pdf)
