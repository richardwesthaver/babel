#!/bin/sh
# bundle a tar.zst archive of Mercurial repositories.
# 
# run this from parent directory (~/src)
CD=$(pwd)
WD=$HOME/stash/tmp
OUT=$WD/bundle
BUNDLE_NAME=bundle-$(date "+%Y%m%d").tar.zst

echo "Bundling all repositories..."

mkdir -pv $OUT
rm -rf $OUT/*
rm -rf $WD/$BUNDLE_NAME
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

    cd $CD
done

pushd $CD
cd $WD
tar -I zstd -cf $BUNDLE_NAME bundle
popd

echo "Done."
