#!/bin/bash
# generate inline documentation for my rust libraries
set -eu

WD=/mnt/src

pushd $WD
for i in rlib tenex; do # shed
    echo "";
    echo "generating rust_docs for $i";
    cd "$i";
    cargo +nightly doc --target-dir ~/stash/tmp/rust_docs/$i --all-features --workspace --no-deps;
    cd $WD;
done
popd
