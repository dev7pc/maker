SHELL = /bin/bash

SELF := $(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))
DIR := $(dir $(lastword $(MAKEFILE_LIST)))
PROJECT_TYPE := $(notdir $(basename $(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))))

.DEFAULT_GOAL = test

include $(DIR)../git.mk
include $(DIR)../terminal.mk
include $(DIR)../components/authors.mk
include $(DIR)../components/changelog.mk
include $(DIR)../components/composer.mk
include $(DIR)../components/phpunit.mk
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
	@mkdir '$(TEST_DIR)'
	$(DONE)

clean: clean-pre .clean clean-post
clean-pre:: ;
clean-post:: ;
.clean: composer-clean ;

distclean: distclean-pre .distclean distclean-post
distclean-pre:: ;
distclean-post:: ;
.distclean: composer-distclean ;

dependencies: dependencies-pre .dependencies dependencies-post
dependencies-pre:: ;
dependencies-post:: ;
.dependencies: composer-install ;

test: test-pre .test test-post
test-pre:: ;
test-post:: ;
.test: phpunit-test ;

.PHONY: \
$(PROJECT_TYPE) \
setup-message \
setup \
clean clean-pre .clean clean-post \
dependencies dependencies-pre .dependencies dependencies-post \
distclean distclean-pre .distclean distclean-post \
test test-pre .test test-post

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
		"phpunit/phpunit": "^$(PHPUNIT_VERSION)"
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
PHPUNIT_VERSION = $(PHPUNIT_VERSION)
TEST_DIR = $(TEST_DIR)

include $(SELF)

.DEFAULT_GOAL = $(.DEFAULT_GOAL)

clean-pre:: ;
clean-post:: ;

composer-install-pre:: ;
composer-install-post:: ;

composer-validate-pre:: ;
composer-validate-post:: ;

dependencies-pre:: ;
dependencies-post:: ;

distclean-pre:: ;
distclean-post:: ;

phpunit-test-pre:: ;
phpunit-test-post:: ;

test-pre:: ;
test-post:: ;
endef
export MAKEFILE
Makefile:
	@echo "$$MAKEFILE" > '$@'
