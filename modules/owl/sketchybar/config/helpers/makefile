SUBDIRS = event_providers menus

.PHONY: all clean $(SUBDIRS)

all: $(SUBDIRS)

$(SUBDIRS):
	@$(MAKE) -C $@ >/dev/null

clean:
	@for dir in $(SUBDIRS); do \
		($(MAKE) -C $$dir clean) >/dev/null; \
	done
