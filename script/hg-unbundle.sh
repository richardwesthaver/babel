#!/bin/sh
# unbundle a tar.zst archive of Mercurial repositories.
CD=$(pwd)
WD=$HOME/stash/tmp
BUNDLE_NAME=bundle-$(date "+%Y%m%d")*
PKG_DIR=$HOME/pkg/hg

for i in $(find $WD -name $BUNDLE_NAME); do
    echo "unbundling $BUNDLE_NAME to $PKG_DIR/bundle"
    # the zstd options for tar no work for me, decompress archive (this should be MacOS only, maybe Win. need to add checks)
    unzstd $i.tar.zst
    tar -xvf $i.tar -C $PKG_DIR
    rm -rf $i.tar.zst $i.tar
echo "Done."
done
