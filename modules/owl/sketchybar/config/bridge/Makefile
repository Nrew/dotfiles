.PHONY: all clean

SUBDIRS = network_load menus

all: $(SUBDIRS)

$(SUBDIRS):
	@$(MAKE) -C $@ >/dev/null

clean:
	@for dir in $(SUBDIRS); do \
		$(MAKE) -C $$dir clean >/dev/null; \
	done