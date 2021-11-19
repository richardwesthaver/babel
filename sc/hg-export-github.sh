#!/bin/sh
# export REPO to github mirror
REPO=meta
SRC=$SHED/src/$REPO
REMOTE=git@github.com:richardwesthaver/$REPO.git
WD=$STAMP

rm -rf $WD/$REPO
git clone $REMOTE $WD/$REPO

pushd $WD/$REPO

case $REPO in
    meta) cp -rf $SRC/{m.org,n.org,cv.org,index.org,ox.setup,readme.org} ./ ;;
    shed) cp -rf $SRC/{Cargo.toml,build.rs,lisp,makefile,src,readme.org,rustfmt.toml} ./ ;;
    babel) cp -rf $SRC/{babel.el,lob.org,readme.org,makefile,sc} ./ ;;
    rlib) cp -rf $SRC/{Cargo.toml,.cargo,rustfmt.toml,src,alch,audio,crypto,db,eve,flate,fu,hash,kala,logger,math,net,obj,organ,tests,ui,util,readme.org} ./ ;;
    cfg) cp -rf $SRC/{emacs,mail,shell,term,tmux,vc,virt,wm,readme.org} ./ ;;
    tenex) cp -rf $SRC/{src,aws,google,readme.org,rustfmt.toml,Cargo.toml} ./ ;;
esac
git add .
git commit -m "from https://hg.rwest.io/$REPO"
git push
popd
