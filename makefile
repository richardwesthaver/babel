-include tp/1.mk
MD=mkdir -p $(@)
BABEL:=$(SHED)/babel

_:c $(STAMPP)/b.tz
c:;rm -rf $(STAMPP)/b.tz $(BABEL)/*
.PHONY: _ c

$(BABEL)/%:sc sn tp;$(MD);install -C -d -m 744 $^ $@
$(STAMPP)/b.tz:$(BABEL);$(MD);shed pack $< $@/b.tz
