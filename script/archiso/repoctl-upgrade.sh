#!/usr/bin/sh
# upgrade packages using repoctl program in correct build order
set -e

BO=$REPO/build-order.txt

repoctl down -u -o $BO
for pkg in $(cat $BO); do
    (
        cd "$pkg"
        makepkg -cs
        repoctl add *.pkg.tar.zst
        cd ..
        rm -rf "$pkg"
    )
done
