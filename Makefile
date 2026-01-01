TARGET 		:= addon
DIR_SRC 	:= src
DIR_BUILD	:= build
DIR_TEST	:= test
SRC_CC 		:= $(DIR_SRC)/$(TARGET).cc
SRC_JS 		:= $(DIR_SRC)/*.js
OUT_CC 		:= $(DIR_BUILD)/$(TARGET).node
OUT_JS 		:= $(DIR_BUILD)/$(TARGET).js

NODE_ARR	:= $(shell node -p "const p=require('path'); \
	[p.resolve(process.execPath, '..', '..'), require('node-addon-api').include].join(' ')")
NODE_INC	:= $(word 1, $(NODE_ARR))/include/node
NAPI_INC	:= $(word 2, $(NODE_ARR))
CXX      	:= g++
CXXFLAGS 	:= -std=c++17 -fPIC -fexceptions -DNODE_ADDON_API_ENABLE_MAYBE
INCLUDES 	:= -I$(NODE_INC) -I$(NAPI_INC)

# multi-thread make with system's total CPU/processors
#   uses (Linux || macOS || Windows || 1)
NPROCS		:= $(shell nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo "$$NUMBER_OF_PROCESSORS")
NPROCS		?= 1
MAKEFLAGS	+= -j$(NPROCS)

ifeq ($(shell uname), Darwin)
	LDFLAGS := -undefined dynamic_lookup -dynamiclib
else
	LDFLAGS := -shared
endif

# log colors
RED     := $(shell tput setaf 9)  # [1, 9, 124, 160, 196, 202]
ORANGE  := $(shell tput setaf 208)  # [166, 202, 208, 214]
GREEN   := $(shell tput setaf 2)  # [2, 10, 40, 41, 70, 71]
RESET   := $(shell tput sgr0)     # default color

# error/ok log utils
DONE_ERROR  = printf "$(strip $(RED))error: %s$(RESET)\n" >&2
DONE_OK     = printf "$(strip $(GREEN))%s ✓$(RESET)\n"
WATCHING    = printf "$(strip $(ORANGE))%s$(RESET)\n"

.PHONY: all clean build test dev build-watch test-watch
.NOTPARALLEL: clean

all: build test
build: $(OUT_CC) $(OUT_JS)
clean:
	@ echo cleaning...
	@ rm -rf $(DIR_BUILD)
	@ $(DONE_OK) "cleaning"

$(OUT_CC): $(SRC_CC)
	@ echo building C/C++...
	@ mkdir -p $(DIR_BUILD)
	@ $(CXX) $(CXXFLAGS) $(INCLUDES) $(LDFLAGS) $< -o $@
	@ $(DONE_OK) "building C/C++"

$(OUT_JS): $(SRC_JS)
	@ echo building JS...
	@ mkdir -p $(DIR_BUILD)
	@ find src -name "*.js" -print0 | xargs -0 -I {} cp {} build/
	@ $(DONE_OK) "building JS"

test:
	@echo "testing..."
	@NODE_FILES="$(DIR_BUILD)/*.node"; \
	FILES="$$(ls $$NODE_FILES 2>/dev/null)"; \
	if [ -n "$$FILES" ]; then \
		node --experimental-addon-modules --no-warnings=ExperimentalWarning $(DIR_TEST)/*.js; \
		$(DONE_OK) "testing"; \
	else \
		$(DONE_ERROR) "$$NODE_FILES files don't exist. Consider \"make build\" first"; \
		exit 1; \
	fi

# developer mode to rebuild/retest on file changes
WATCHFLAGS	:= MAKEFLAGS= --no-print-directory
dev: build
	@$(MAKE) $(WATCHFLAGS) build-watch & \
		$(MAKE) $(WATCHFLAGS) test-watch & wait
build-watch:
	@$(WATCHING) "watching source files"
	@watchexec --quiet --exts cc,js --ignore $(DIR_BUILD) --watch $(DIR_SRC) -- $(MAKE) $(WATCHFLAGS) --quiet build
test-watch: build
	@sleep 0.01 # ensures echo below is complete after build-watch starts
	@$(WATCHING) "watching test files"
	@watchexec --quiet --exts node,js --watch test --no-vcs-ignore \
		--watch $(DIR_BUILD) -- $(MAKE) $(WATCHFLAGS) --quiet test
