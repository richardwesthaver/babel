#!/bin/sh
# create 4k of random bytes in file
dd if=/dev/urandom of=~/urandom_test count=4 bs=1024
# generate random numbers to stdout
od -d /dev/urandom
# a variant with hashing
dd if=/dev/urandom  count=1 bs=128 | sha512sum
