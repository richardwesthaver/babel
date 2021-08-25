#!/bin/sh
# unbundle a tar.zst archive of Mercurial repositories.
# this will generate a directory name 'bundle' in '~/pkg/hg/'
WD=$HOME/stash/tmp
BUNDLE_NAME=bundle-$(date "+%Y%m%d")
PKG_DIR=$HOME/pkg/hg
echo "unbundling $i to $PKG_DIR/bundle"
# the zstd options for tar no work for me, decompress archive (this should be MacOS only, maybe Win. need to add checks)
unzstd $WD/$BUNDLE_NAME.tar.zst
tar -xvf $WD/$BUNDLE_NAME.tar -C $PKG_DIR
rm -rf $WD/$BUNDLE_NAME.tar.zst $WD/$BUNDLE_NAME.tar
echo "Done."
