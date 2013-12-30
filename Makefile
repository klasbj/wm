
COMPONENTS := dwm dzcoord

.PHONY: all
all: $(COMPONENTS)

.PHONY: $(COMPONENTS)
$(COMPONENTS):
	@echo ">> Make $@"
	@cd $@; make
