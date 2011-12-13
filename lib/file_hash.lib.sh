#!/bin/bash

##
## md5sum, sha1 and friends are useful for hashing files
## These functions make it easier to get just the hash
##

# Parses the output of md5sum, sha1sum and friends
function parse_hash {
    sed -ne 's/\([0-9,a-f]\+\).*/\1/p'
}

# Eg:
#   $ hash md5sum "Foo"
#   1356c67d7ad1638d816bfb822dd2c25d
function hash_arg {
    echo -n "$2" | "$1" | parse_hash
}

# Eg:
#  $ hash md5sum /bin/sh
#  2e836b6d95c58dcd4d0966a5eee1e5c0
function hash_file {
    "$1" "$2" | parse_hash
}

# Eg:
#  $ echo Hello | hash_stdin md5sum
#  09f7e02f1290be211da707a266f153b3
function hash_stdin {
    "$1" | parse_hash
}

