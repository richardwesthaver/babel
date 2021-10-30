#@!/usr/bin/make -f -j8
B:=$(SHED)/babel

.PHONY: c

o:lob.org sc;mkdir -p $@;cp -r $^ $@;\
emacsclient -q -e '(org-babel-tangle-file "o/$<")' ;\
shc pack $@ $@/b.tz

c:;rm -rf o

b.tz:
