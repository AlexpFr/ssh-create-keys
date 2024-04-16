#!/bin/bash
#
# ARGBASH_SET_DELIM([ ])
# ARG_RESTRICT_VALUES([no-any-options])
#
# ARG_OPTIONAL_INCREMENTAL([verbose], [v], [Verbose mode, you can repeat this 2 times (0 by default)], [0])
# ARG_OPTIONAL_BOOLEAN([create-files],[f],[Create files in current folder])
# ARG_OPTIONAL_BOOLEAN([print],[p],[print private-public key on terminial])
#
# ARG_OPTIONAL_SINGLE([comment],[C],[custom comment],[AAAA-MM-JJTHH:MM:SSZ])
# ARG_OPTIONAL_SINGLE([passphrase],[P],[custom passphrase])
# ARG_OPTIONAL_SINGLE([rounds],[a],[KDF rounds],[16])
#
# ARG_TYPE_GROUP([nnint],[integer],[rounds])
# ARG_TYPE_GROUP([string],[string],[comment, passphrase])
#
# ARG_VERSION([echo $version],[V])
# ARG_HELP([Passphrase and public/private ed25519 key pair generator.])
# ARGBASH_GO()
#
# [ <-- needed because of Argbash

# ] <-- needed because of Argbash
