#!/bin/sh
# export a collection of hg.BUNDLESPEC files to REMOTE stash/tmp.
REMOTE=jekyll
WD=$HOME/stash/tmp
BUNDLE_NAME=bundle-$(date "+%Y%m%d").tar.zst

echo "exporting $BUNDLE_NAME from $HOSTNAME to $REMOTE"
scp $WD/$BUNDLE_NAME ellis@$REMOTE:~/stash/tmp
echo "Done."
