
COMPONENTS := dwm

.PHONY: all
all: $(COMPONENTS)

.PHONY: $(COMPONENTS)
$(COMPONENTS):
	@echo ">> Make $@"
	@cd $@; make
