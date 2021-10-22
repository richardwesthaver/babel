#@!/usr/bin/make -f -j8
B:=$(SHED)/babel

.PHONY: c

o:lob.org sc;mkdir -p $@;cp -r $^ $@
	emacs --eval '(org-babel-tangle-file "o/$<")'
	shed pack $@ $@/b.tz

c:;rm -rf o

b.tz:
