CC = clang
CFLAGS = -std=c99 -O3 -Wall -Wextra
TARGET = network_load
BINDIR = bin
SRCS = network_load.c
HEADERS = network_load.h ../sketchybar.h

all: $(BINDIR)/$(TARGET)

$(BINDIR)/$(TARGET): $(SRCS) $(HEADERS) | $(BINDIR)
	$(CC) $(CFLAGS) $(SRCS) -o $@

$(BINDIR):
	mkdir -p $(BINDIR)

.PHONY: clean
clean:
	rm -rf $(BINDIR)/$(TARGET)
