#!/bin/bash
# bundle a tar.zst archive of Mercurial repositories.

CD=$(pwd)
WD=$HOME/stash/tmp
OUT=$WD/bundle
SRC_PATH=$HOME/src
BUNDLE_NAME=bundle-$(date "+%Y%m%d_%H%M").tar.zst

echo "Building $BUNDLE_NAME in $WD..."

mkdir -pv $OUT
rm -rf $OUT/*
rm -rf $WD/$BUNDLE_NAME

cd $SRC_PATH

# Find all mercurial repositories, create bundles and dump them to $OUT dir
for i in $(find . -name ".hg" | cut -c 3-); do
    echo "";
    echo $i;

    cd "$i";
    cd ..;
    hg bundle -a -t gzip-v2 $OUT/$(basename $(hg root)).hg.gz;
    hg bundle -a -t zstd-v2 $OUT/$(basename $(hg root)).hg.zst;
    hg bundle -a -t none-v2 $OUT/$(basename $(hg root)).hg;
    hg debugcreatestreamclonebundle $OUT/$(basename $(hg root)).hg.stream;
    echo "... Done.";
    cd $SRC_PATH
done

cd $WD
# this will take a while with ultra mode
tar -I 'zstd --ultra -22' -cf $BUNDLE_NAME bundle/

echo "Done."
