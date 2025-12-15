.PHONY: all clean

CC := gcc
CFLAGS := -g -std=c99 -Wall -Wextra -pedantic

tools := scan_includes gfx

all: $(tools)
	@:

clean:
	rm -f $(tools)

gfx: common.h
%: %.c
	$(CC) $(CFLAGS) -o $@ $<
