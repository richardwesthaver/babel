-include 0.mk
.EXPORT_ALL_VARIABLES:
# DMID:=od -An -N1 -i < /dev/random #placeholder
SHED:=/home/${USER}/shed
DEMON:=$(shell echo ${USER} | tr 'A-Za-z' 'N-ZA-Mn-za-m')dm
STASH:=$(SHED)/stash
STAMP:=$(STASH)/tmp
STAMPP:=$(STAMP)/p

_dmadd:
	useradd $(DEMON) -G demon;
	mkdir -p $(STAMP)/dm/.h/$(DEMON);
	chown -R $(DEMON):demon $(STAMP)/dm/.h/$(DEMON);
	install -C -m 775 -o $(DEMON) -g demon $(STAMPP) $(STAMP)/dm/.h/$(DEMON)

_dmkill:
	userdel -f -r $(DEMON);
	rm -rf $(STAMP)/dm/.h/$(DEMON)

_list: #requires xargs awk egrep
	@$(MAKE) -pRrq -f \ 
	$(lastword $(MAKEFILE_LIST)) : \
		2>/dev/null | awk -v RS= -F: \
		'/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' \
		| sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$' | xargs

.DEFAULT_GOAL := #reset default
