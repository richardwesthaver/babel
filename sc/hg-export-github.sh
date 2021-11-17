#!/bin/sh
# export REPO to git REMOTE
REPO=meta
SRC=$SHED/src/$REPO
REMOTE=git@github.com:richardwesthaver/$REPO.git
WD=$STAMP

rm -rf $WD/$REPO
git clone $REMOTE $WD/$REPO
pushd $WD/$REPO
#cp -rf $SRC/{Cargo.toml,build.rs,lisp,makefile,src,readme.org,rustfmt.toml} ./ 
cp -rf $SRC/{m.org,n.org,cv.org,index.org,ox.setup,readme.org} ./
#cp -rf $SRC/{babel.el,lob.org,readme.org,makefile,sc} ./
#cp -rf $SRC/{Cargo.toml,.cargo,rustfmt.toml,src,alch,audio,crypto,db,eve,flate,fu,hash,kala,logger,math,net,obj,organ,tests,ui,util,readme.org} ./
#cp -rf $SRC/{emacs,mail,shell,term,tmux,vc,virt,wm,readme.org} ./
git add .
git commit -m "mirror export $(date '+%Y%m%d') from hg.rwest.io/$REPO"
git push
popd
