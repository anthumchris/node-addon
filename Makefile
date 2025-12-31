# TODO: AI LLM initially created this file for binding.gyp » Makefile. review/revise

TARGET 		:= addon
DIR_SRC 	:= src
DIR_BUILD	:= build
DIR_TEST	:= test
SOURCE 		:= $(DIR_SRC)/$(TARGET).cc
OUTPUT 		:= $(DIR_BUILD)/$(TARGET).node

# Manual header discovery via the 'node' binary location
NODE_PATH	:= $(shell node -e "console.log(require('path').resolve(process.execPath, '..', '..'))")
NODE_INC	:= $(NODE_PATH)/include/node
NAPI_INC	:= $(shell node -p "require('node-addon-api').include")

# multi-thread make with system's CPU/processor num
#   uses Linux || macOS || Windows || 1
NPROCS		:= $(shell nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo "$$NUMBER_OF_PROCESSORS")
NPROCS		?= 1
MAKEFLAGS	+= -j$(NPROCS)

CXX      	:= g++
CXXFLAGS 	:= -std=c++17 -fPIC -fexceptions -DNODE_ADDON_API_ENABLE_MAYBE
INCLUDES 	:= -I$(NODE_INC) -I$(NAPI_INC)

RED     := $(shell tput setaf 9)	# [1, 9, 124, 160, 196, 202]
GREEN   := $(shell tput setaf 2)	# [2, 10, 40, 41, 70, 71]
RESET   := $(shell tput sgr0)	# Reset terminal to default
ERROR   = printf "$(strip $(RED))error: %s$(RESET)\n" >&2
OK      = printf "$(strip $(GREEN))%s$(RESET)\n"

ifeq ($(shell uname), Darwin)
	LDFLAGS := -undefined dynamic_lookup -dynamiclib
else
	LDFLAGS := -shared
endif

.PHONY: all clean build test dev watch-make watch-test
.NOTPARALLEL: clean

all: build

clean:
	@ echo cleaning...
	@ rm -rf $(DIR_BUILD)
	@ $(OK) "cleaning ✓"

# developer mode to rebuild/retest on file changes
dev: watch-make watch-test
watch-make:
	@ trap 'exit 0' INT; while true; do find src -name "*.cc" | entr -rnd $(MAKE) build; done
watch-test:
	@ trap 'exit 0' INT; while true; do find lib $(DIR_TEST) $(DIR_BUILD)/*.node -type f | entr -rnd $(MAKE) test; done

build: $(OUTPUT)

test:
	@echo "testing..."
	@NODE_FILES="$(DIR_BUILD)/*.node"; \
	FILES="$$(ls $$NODE_FILES 2>/dev/null)"; \
	if [ -n "$$FILES" ]; then \
		node --experimental-addon-modules --no-warnings=ExperimentalWarning $(DIR_TEST)/*.js; \
		$(OK) "testing ✓"; \
	else \
		$(ERROR) "$$NODE_FILES files don't exist. Consider \"make build\" first"; \
		exit 1; \
	fi

$(OUTPUT): $(SOURCE)
	@ echo building...
	@ mkdir -p $(DIR_BUILD)
	@ $(CXX) $(CXXFLAGS) $(INCLUDES) $(LDFLAGS) $< -o $@
	@ $(OK) "building ✓"
