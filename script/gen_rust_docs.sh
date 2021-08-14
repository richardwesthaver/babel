#!/bin/bash
# generate inline documentation for all rust projects
set -eu

CD=$(pwd)
TARGET=
for i in 
pushd ~/src/tenex
RUSTDOCFLAGS="--enable-index-page -Zunstable-options" cargo +nightly doc --target-dir 
popd

pushd ~/shed/src/bin
RUSTDOCFLAGS="--enable-index-page -Zunstable-options" cargo +nightly doc --target-dir ~/stash/public/bin-docs --no-deps
popd
