#!/bin/sh
# unbundle a tar.zst archive of Mercurial repositories.
CD=$(pwd)
WD=$HOME/stash/tmp
BUNDLE_NAME=bundle-$(date "+%Y%m%d")
PKG_DIR=$HOME/pkg/hg

echo "unbundling $BUNDLE_NAME to $PKG_DIR"
unzstd $WD/$BUNDLE_NAME.tar.zst
tar -xvf $WD/$BUNDLE_NAME.tar -C $WD/
mv $WD/bundle/* $PKG_DIR/
rm -rf $WD/$BUNDLE_NAME.tar $WD/bundle
