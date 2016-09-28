SHELL = /bin/bash

SELF := $(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))
DIR := $(dir $(lastword $(MAKEFILE_LIST)))

include $(DIR)terminal.mk

PROJECT_TYPE ?= $(firstword $(MAKECMDGOALS))
PROJECT_MAKE = $(DIR)project-types/$(PROJECT_TYPE).mk

ifeq ($(PROJECT_TYPE),)
  $(call ERROR,"Usage: make --file='$(SELF)' [project-type]",[project-type] not specified)

else ifeq ($(shell ls '$(PROJECT_MAKE)' 2> /dev/null),)
  $(call ERROR,"Unknown project type: $(PROJECT_TYPE)",File not found: $(PROJECT_MAKE))

else
  include $(PROJECT_MAKE)
endif
