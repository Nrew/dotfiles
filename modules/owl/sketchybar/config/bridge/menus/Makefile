CC := clang
CFLAGS := -std=c99 -O3 -F/System/Library/PrivateFrameworks/ -framework Carbon -framework SkyLight
TARGET := menus
SRC := menus.c
BINDIR := bin
HEADERS := menus.h

all: $(BINDIR)/$(TARGET)

$(BINDIR)/$(TARGET): $(SRC) $(HEADERS) | $(BINDIR)
	$(CC) $(CFLAGS) $(SRC) -o $@

$(BINDIR):
	mkdir -p $(BINDIR)

.PHONY: clean
clean:
	rm -rf $(BINDIR)
