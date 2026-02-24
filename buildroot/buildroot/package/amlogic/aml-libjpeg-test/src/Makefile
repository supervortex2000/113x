SRC_DIRS = .

CFLAGS += $(addprefix -I, $(SRC_DIRS))

LDFLAGS += -ljpeg

SRCS = $(foreach dir,$(SRC_DIRS),$(wildcard $(dir)/*.c))
OBJDIR = objs
OBJS = $(addprefix $(OBJDIR)/,$(notdir $(SRCS:.c=.o)))

TARGET = $(OUTPUT)
all: $(TARGET)

$(TARGET): $(OBJS)
	@echo " [LINK] $@"
	@$(CC) -o $@ $(LDFLAGS) $^

$(OBJDIR)/%.o: %.c $(OBJDIR)/%.d
	@echo " [CC] $<"
	@$(CC) $(CPPFLAGS) $(CFLAGS) -o $@ -c $<

$(OBJDIR)/%.d: %.c
	@echo " [DEP] $<"
	@mkdir -p $(OBJDIR)
	@$(CC) $(CPPFLAGS) $(CFLAGS) -M -MT "$(patsubst %.c,$(OBJDIR)/%.o,$<)" $< -MF $@

.PHONY:clean

clean:
	@echo " [CLEAN] ..."
	@rm -rf $(OBJDIR) $(TARGET)


