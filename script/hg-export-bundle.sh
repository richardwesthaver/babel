#!/bin/sh
# export a collection of hg.BUNDLESPEC files to REMOTE stash/tmp.
REMOTE=jekyll
WD=$HOME/stash/tmp
BUNDLE_NAME=bundle-$(date "+%Y%m%d")*.tar.zst

for i in $(find $WD -name $BUNDLE_NAME); do
    echo "exporting $i from $HOSTNAME to $REMOTE"
    scp $i $REMOTE:~/stash/tmp
    echo "Done."
done
