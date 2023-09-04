#!/usr/bin/env sh
pushd ~/stash/sbcl
./make.sh --without-gencgc --with-mark-region-gc --with-core-compression --with-sb-xref-for-internals
INSTALL_ROOT=~/shed/sbcl ./install.sh # installs to ~/bin/sbcl
ln -sf ~/shed/sbcl/bin/sbcl ~/bin/sbcl
popd
