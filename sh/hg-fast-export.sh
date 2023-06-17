#!/usr/bin/env sh
CD=$PWD
FE=PYTHON=python3.11 ~/stash/fast-export/hg-fast-export.sh
NAME=$(basename $CD)
git init /tmp/$NAME
pushd /tmp/$NAME
git config core.ignoreCase false && git config push.followTags true &&
# '-M default' = no more masters
$FE -r $CD -M default && git checkout HEAD
git remote add gh git@github.com:richardwesthaver/$NAME.git
git push gh --all --force
popd
rm -rf /tmp/$NAME
