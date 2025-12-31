# AI LLM made this file when I requested conversion from binding.gyp to Makefile
# TODO: review/revise

TARGET 		:= addon
SRC_DIR 	:= src
BUILD_DIR := build
SOURCE 		:= $(SRC_DIR)/$(TARGET).cc
OUTPUT 		:= $(BUILD_DIR)/$(TARGET).node

# Manual header discovery via the 'node' binary location
NODE_PATH := $(shell node -e "console.log(require('path').resolve(process.execPath, '..', '..'))")
NODE_INC  := $(NODE_PATH)/include/node
NAPI_INC  := $(shell node -p "require('node-addon-api').include")

CXX      	:= g++
CXXFLAGS 	:= -std=c++17 -fPIC -fexceptions -DNODE_ADDON_API_ENABLE_MAYBE
INCLUDES 	:= -I$(NODE_INC) -I$(NAPI_INC)

ifeq ($(shell uname), Darwin)
	LDFLAGS := -undefined dynamic_lookup -dynamiclib
else
	LDFLAGS := -shared
endif

.PHONY: all clean

all: $(OUTPUT)

$(OUTPUT): $(SOURCE)
	@ mkdir -p $(BUILD_DIR)
	@ $(CXX) $(CXXFLAGS) $(INCLUDES) $(LDFLAGS) $< -o $@

clean:
	@ rm -rf $(BUILD_DIR)
