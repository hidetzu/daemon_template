##################
# makefile
#
AT     = @

CC     = gcc
ECHO   = $(AT)echo
MKDIR  = $(AT)mkdir -p
RM     = $(AT)rm -rf
MAKE   = $(AT)make --no-print-directory 


##################
# configs
#
USE_DEBUG=yes
USE_COV=yes


############
# project dir settings
TARGET=daemon_template
PROJECT_TOP=.
PROJECT_SRC_DIR=$(shell find src -type d)

OUTPUT_DIR=$(PROJECT_TOP)/work
BIN_DIR=$(OUTPUT_DIR)/bin
MAKE_DIR=$(PROJECT_TOP)/build


INCLUDES  = -I./include
CFLAGS    = -Wall
LDFLAGS   = -lpthread

ifeq ($(USE_DEBUG), yes)
CFLAGS += -g
endif

ifeq ($(USE_COV), yes)
CFLAGS += -fprofile-arcs -ftest-coverage
LDFLAGS+= -fprofile-arcs
endif


############
# unittest dir settings
#UNITTEST_TOP=$(PROJECT_TOP)/unittest
#UNITTEST_WORK=$(PROJECT_TOP)/unittest_work
#UNITTEST_TARGET=$(TARGET)_CppUTest_tests

############
# helpers
include build/helpers.mk

SRCS += $(call get_src_from_dir_list, $(PROJECT_SRC_DIR))
SRCS += daemon/main.c

objects = $(call src_to_o, $(SRCS))


.PHONY: all clean
all: $(BIN_DIR)/$(TARGET)

$(BIN_DIR)/$(TARGET):$(objects)
	$(ECHO) linking $(notdir $<)
	$(MKDIR) $(dir $@)
	$(CC) -o $@ $^ $(LDFLAGS)

$(OUTPUT_DIR)/%.o:%.c
	$(ECHO) compiling $(notdir $<)
	$(MKDIR) $(dir $@)
	$(CC) $(CFLAGS) $(INCLUDES) -o $@ -c $<

lcov:
	$(MAKE) SRC_DIR="$(PROJECT_SRC_DIR)" OUTPUT_DIR="$(OUTPUT_DIR)" -f $(MAKE_DIR)/lcov.mk

clean:
	$(RM) $(OUTPUT_DIR) $(TARGET)

############
# utils

tags:
	$(RM) tags
	@find . -name "*.[ch]" | xargs ctags


###################
# for unittest
#
#.PHONY: unittest unittest_clean
#
#unittest:
#	$(MKDIR) $(UNITTEST_WORK)/lib
#	$(MAKE) TARGET=$(TARGET) PROJECT_TOP=$(PROJECT_TOP) UNITTEST_TOP=$(UNITTEST_TOP) PROJECT_SRC_DIR="$(PROJECT_SRC_DIR)" -f unittest/MakefileCppUTest.mk
#
#unittest_clean:
#	$(RM) $(UNITTEST_WORK) $(UNITTEST_TARGET)
