#@!/usr/bin/make -f -j8
-include tp/1.mk
BABEL=$(SHED)/babel

.PHONY: i c
i:sc sn tp;mkdir -p $(BABEL) $(STAMPP);install -C -d -m 744 $^ $(BABEL)
	shed pack $(BABEL) $(STAMPP)/b.tz
c:;rm -rf $(STAMPP)/b.tz $(BABEL)/*
