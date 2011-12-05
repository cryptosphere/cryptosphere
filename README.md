The Cryptosphere
================

The Cryptosphere is a global peer-to-peer cryptosystem for publishing and
securely distributing content anonymously with no central point of failure.
The system is openly federated and anyone can join. To ensure quality service
and prevent abuse, the Cryptosphere uses an integrated cryptographically
secure reputation system which provides a distributed web of trust.

There are several systems with similar goals to the Cryptosphere, such as
MNet, Freenet, and Tahoe-LAFS. These systems serve as inspiration for the
Cryptosphere's design. The Cryptosphere is also heavily influenced by Git, the
distributed version control system.

How the Cryptosphere stores data
--------------------------------

As you might expect from the name, all data within the Cryptosphere is
encrypted, using a technique called convergent encryption. Convergent
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