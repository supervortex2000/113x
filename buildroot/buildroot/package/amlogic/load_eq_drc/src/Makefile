#
## Makefile for load eq&drc params
#
#
OBJ = loadEqDrcParams.o
CFLAGS = -Wall -Wextra
LDFLAGS = -ldl -lasound
TARGET=load_eq_drc

# rules
all: $(TARGET)

$(TARGET): $(OBJ)
	$(CC) $(LDFLAGS) $^  -o $@

%.o: %.c
	$(CC) -fPIC $(CFLAGS) -c $^ -o $@

.PHONY: clean

clean:
	rm -f $(OBJ)

install:
	cp load_eq_drc $(DESTDIR)/bin/load_eq_drc
