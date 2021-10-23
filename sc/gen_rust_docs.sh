#!/bin/bash
# generate API docs for all rust projects
set -eu

WD=$SHED/src

mkdir -p $STAMP/rdoc

pushd $WD
for i in rlib tenex shed; do # shed
    echo "\ngenerating rust_docs for $i";
    pushd $i;
    cargo +nightly doc --no-deps --target-dir $STAMP/rdoc/$i --all-features --workspace --release --message-format short;
    popd;
done
popd
