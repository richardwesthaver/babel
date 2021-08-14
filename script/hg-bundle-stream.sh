#!/usr/bin/bash
# run this from parent directory (~/src)
CD=$(pwd)
OUT=/tmp/bundle
echo "Bundling all local repositories..."

mkdir -p $OUT
# Find all mercurial repositories, create stream-v2 and zstd-v2 bundles
for i in $(find . -name ".hg" | cut -c 3-); do
    echo "";
    echo $i;
    cd "$i";
    cd ..;
    hg bundle -a -t none-v2 $OUT/$(basename $(hg root)).hg.stream;
    cd $CD
done

echo "Done."
