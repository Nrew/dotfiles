CC := clang
CFLAGS := -std=c99 -O3 -F/System/Library/PrivateFrameworks/ -framework Carbon -framework SkyLight
TARGET := bin/menus
SRC := menus.c
OBJ := $(SRC:.c=.o)
BIN_DIR := bin

$(TARGET): $(SRC) | $(BIN_DIR)
	$(CC) $(CFLAGS) $< -o $@

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

clean:
	rm -rf $(BIN_DIR)