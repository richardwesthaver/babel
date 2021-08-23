#!/bin/sh
# export crater/index to git REMOTE
CD=$(pwd)
CRATER=$HOME/src/crater
REMOTE=git@github.com:richardwesthaver/crater-index.git
WD=$HOME/stash/tmp

git clone $REMOTE $WD/crater-index && cd $WD/crater-index
git remote add origin $REMOTE
cp -rf $CRATER/index/** ./ 
git commit -m "crater-index export $(date '+%Y%m%d') from https://hg.rwest.io/crater"
git push origin master
cd $CD
