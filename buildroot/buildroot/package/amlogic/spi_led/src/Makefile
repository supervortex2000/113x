#
## Makefile for spi_led
#
#
OBJ = spi_led.o
CFLAGS = -Wall -Wextra
TARGET=spi_led

# rules
all: $(TARGET)

$(TARGET): $(OBJ)
	$(CC) $^ -o $@

%.o: %.c
	$(CC) -c $(CFLAGS) $^ -o $@

.PHONY: clean

clean:
	rm -f $(OBJ)

install:
	cp spi_led $(DESTDIR)/bin/spi_led
