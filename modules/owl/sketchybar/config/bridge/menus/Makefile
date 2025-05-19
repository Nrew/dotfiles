CC := clang
CFLAGS := -std=c99 -O3 -F/System/Library/PrivateFrameworks/ -framework Carbon -framework SkyLight
TARGET := bin
SRC := menus.c
BIN_DIR := bin
HEADERS := menus.h

all: $(TARGET)

$(TARGET): $(SRC) $(HEADERS) | $(BIN_DIR)
	$(CC) $(CFLAGS) $(SRC) -o $@

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

.PHONY: clean
clean:
	rm -rf $(BIN_DIR)
