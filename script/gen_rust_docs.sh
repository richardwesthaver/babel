#!/bin/bash
# generate inline documentation for all rust projects
set -eu

WD=~/src

pushd $WD
for i in demo store stash rlib tenex; do # shed
    echo "";
    echo "generating rust_docs for $i";
    cd "$i";
    cargo +nightly doc --target-dir ~/stash/tmp/rust_docs;
    cd $WD;
done
popd
