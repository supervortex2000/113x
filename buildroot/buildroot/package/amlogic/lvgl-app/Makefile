#
# Makefile
#
LVGL_DIR_NAME := lvgl
LV_DRIVERS_DIR_NAME := lv_drivers
LVGL_DIR := ${shell pwd}
CFLAGS += -O3 -g0 -I$(LVGL_DIR)/ -I$(LVGL_DIR)/lvgl -I$(LVGL_DIR)/lv_drivers
LDFLAGS += -lm
BIN = lvgl-app

LVGL_TARGET = liblvgl.a
LV_DRIVERS_TARGET = liblv_drivers.a

LVGL_SRCS += $(shell find -L $(LVGL_DIR)/$(LVGL_DIR_NAME)/src -name "*.c")
LVGL_OBJS := $(LVGL_SRCS:.c=.o)

LV_DRV_SRCS += $(shell find -L $(LVGL_DIR)/$(LV_DRIVERS_DIR_NAME) -name "*.c")
LV_DRV_OBJS := $(LV_DRV_SRCS:.c=.o)

ifeq ($(BR2_PACKAGE_LVGL_DEMOS),y)
LV_DEMO_SRCS += $(shell find -L $(LVGL_DIR)/lv_demos -name "*.c")
LV_DEMO_OBJS := $(LV_DEMO_SRCS:.c=.o)

CFLAGS += -DENABLE_LVGL_DEMOS -I$(LVGL_DIR)/lv_demos
endif

all: $(LVGL_TARGET) $(LV_DRIVERS_TARGET) $(BIN)

# liblvgl.a
$(LVGL_OBJS):%.o:%.c
	$(CC) -O3 $(CFLAGS) -DLV_CONF_INCLUDE_SIMPLE=1 -g -c $^ -o $@

$(LVGL_TARGET):$(LVGL_OBJS)
	$(AR) -cvr $@ $^

# liblv_drivers.a
$(LV_DRV_OBJS):%.o:%.c
	$(CC) -O3 $(CFLAGS) -DLV_CONF_INCLUDE_SIMPLE=1 -g -c $^ -o $@

$(LV_DRIVERS_TARGET):$(LV_DRV_OBJS)
	$(AR) -cvr $@ $^

# lvgl-app
ifeq ($(BR2_PACKAGE_LVGL_DEMOS),y)
$(LV_DEMO_OBJS):%.o:%.c
	$(CC) -O3 $(CFLAGS) -g -c $^ -o $@

$(BIN): main.o $(LV_DEMO_OBJS) $(LVGL_TARGET) $(LV_DRIVERS_TARGET)
	$(CC) $(CFLAGS) $(LDFLAGS) $^ -o $@
else
$(BIN): main.o lv_app/src/myapp.o $(LVGL_TARGET) $(LV_DRIVERS_TARGET)
	$(CC) $(CFLAGS) $(LDFLAGS) $^ -o $@

lv_app/src/myapp.o: lv_app/src/myapp.c
	$(CC) $(CFLAGS) $(LDFLAGS) -c $< -o $@
endif

main.o: main.c
	$(CC) $(CFLAGS) $(LDFLAGS) -c $< -o $@

clean:
	rm -f $(BIN) $(LVGL_TARGET) $(LV_DRIVERS_TARGET)
	rm -f $(LVGL_OBJS) $(LV_DRV_OBJS)

