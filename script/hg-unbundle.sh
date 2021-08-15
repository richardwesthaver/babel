#!/usr/bin/sh
# unbundle a tar.zst archive of Mercurial repositories.
CD=$(pwd)
WD=$HOME/stash/tmp
BUNDLE_NAME=bundle-$(date "+%Y%m%d").tar.zst
PKG_DIR=$HOME/pkg/hg

echo "unbundling $BUNDLE_NAME to $PKG_DIR"
tar --zstd -xvf $WD/$BUNDLE_NAME -C $WD/
mv $WD/bundle/* $PKG_DIR/
