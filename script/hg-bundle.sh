#!/usr/bin/bash
# run this from parent directory (~/src)
CD=$(pwd)
OUT=$HOME/stash/tmp/bundle
EXPORT_PATH=/mnt/cia/export
echo "Bundling all local repositories..."
mkdir -p $OUT
# Find all mercurial repositories, create bundles and dump them to $OUT dir
for i in $(find . -name ".hg" | cut -c 3-); do
    echo "";
    echo $i;

    cd "$i";
    cd ..;

    hg bundle -a -t gzip-v2 $OUT/$(basename $(hg root)).hg.gz
    hg bundle -a -t zstd-v2 $OUT/$(basename $(hg root)).hg.zst;
    hg bundle -a -t none-v2 $OUT/$(basename $(hg root)).hg;
    hg debugcreatestreamclonebundle $OUT/$(basename $(hg root)).hg.stream;

    cd $CD
done

pushd
cd $HOME/stash/tmp
tar --zstd -cf $EXPORT_PATH/bundle-$(date "+%Y%m%d-%H.%M").tar.zst bundle
popd

echo "Done."
