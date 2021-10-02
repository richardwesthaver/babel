#@!/usr/bin/make -f -j8
-include tp/1.mk
BABEL=$(SHED)/babel

o:sc sn tp;mkdir -p $(BABEL) $(STAMPP);cp -rf $^ $(BABEL)
	shed pack $(BABEL) $(STAMPP)/b.tz
c:;rm -rf $(STAMPP)/b.tz $(BABEL)/*
.PHONY: o c
