SHELL = /bin/bash

SELF := $(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))
DIR := $(dir $(lastword $(MAKEFILE_LIST)))
PROJECT_TYPE := $(notdir $(basename $(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))))

.DEFAULT_GOAL = composer-validate

include $(DIR)../git.mk
include $(DIR)../terminal.mk
include $(DIR)../components/authors.mk
include $(DIR)../components/changelog.mk
include $(DIR)../components/composer.mk
include $(DIR)../components/unlicense.mk

$(PROJECT_TYPE): setup-message setup

setup-message:
	$(call STATUS,'Setting up project of type "$(PROJECT_TYPE)"')

setup: \
AUTHORS \
CHANGELOG.md \
COPYING \
Makefile \
composer.json
	$(DONE)

clean: clean-pre .clean clean-post
clean-pre::
clean-post::
.clean: composer-clean

dependencies: dependencies-pre .dependencies dependencies-post
dependencies-pre:: ;
dependencies-post:: ;
.dependencies: composer-install ;

distclean: composer-distclean

.PHONY: \
$(PROJECT_TYPE) \
setup-message \
setup \
dependencies dependencies-pre .dependencies dependencies-post

define COMPOSER_JSON
{
	"authors": [
		{
			"name": "$(shell git config --get user.name)",
			"email": "$(shell git config --get user.email)"
		}
	],
	"autoload": {
		"psr-4": {
			"SevenPercent\\": "src/"
		}
	},
	"description": "$(notdir $(realpath ./))",
	"license": "Unlicense",
	"name": "sevenpercent/$(notdir $(realpath ./))",
	"require": {
		"php": ">=5.6.0"
	},
	"require-dev": {
	},
	"support": {
		"email": "$(shell git config --get user.email)"
	},
	"type": "library"
}
endef
export COMPOSER_JSON
composer.json:
	@echo "$$COMPOSER_JSON" > '$@'

define MAKEFILE
SHELL = $(SHELL)
COMPOSER_VERSION = $(COMPOSER_VERSION)

include $(SELF)

clean-pre:: ;
clean-post:: ;

composer-install-pre:: ;
composer-install-post:: ;

composer-validate-pre:: ;
composer-validate-post:: ;

dependencies-pre:: ;
dependencies-post:: ;
endef
export MAKEFILE
Makefile:
	@echo "$$MAKEFILE" > '$@'
