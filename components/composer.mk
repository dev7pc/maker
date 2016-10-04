SHELL = /bin/bash

COMPOSER_FILENAME ?= composer.phar
COMPOSER_VERSION ?= 1.2.1

COMPOSER_INSTALLER_URL = https://getcomposer.org/installer
COMPOSER_INSTALLER_CHECKSUM_URL = https://composer.github.io/installer.sig
COMPOSER_INSTALLER_FILENAME = .composer-installer
COMPOSER_INSTALLER_CHECKSUM_FILENAME = $(COMPOSER_INSTALLER_FILENAME).sha384
COMPOSER_FILENAME_PREFIX = composer-
COMPOSER_FILENAME_SUFFIX = .phar
COMPOSER_VERSIONED_FILENAME = $(COMPOSER_FILENAME_PREFIX)$(COMPOSER_VERSION)$(COMPOSER_FILENAME_SUFFIX)

.PHONY: \
$(COMPOSER_FILENAME) \
composer-validate composer-validate-pre .composer-validate composer-validate-post \
composer-install composer-install-pre .composer-install composer-install-post \
composer-clean \
composer-distclean

$(COMPOSER_INSTALLER_CHECKSUM_FILENAME):
	$(call STATUS,'Downloading Composer installer checksum')
	@curl --output '$@' --silent '$(COMPOSER_INSTALLER_CHECKSUM_URL)'
	$(DONE)
	$(call GITIGNORE_ADD,$@)

$(COMPOSER_INSTALLER_FILENAME): \
$(COMPOSER_INSTALLER_CHECKSUM_FILENAME)
	$(call STATUS,'Downloading Composer installer')
	@curl --output '$@' --silent '$(COMPOSER_INSTALLER_URL)'
	$(DONE)
	$(call STATUS,'Validating Composer installer')
	@if type sha384sum > /dev/null 2>&1; then \
		SHA384SUM=sha384sum; \
	else \
		SHA384SUM='shasum --algorithm=384'; \
	fi; \
	test "$$($$SHA384SUM --binary '$@' | awk '{print $$1}')" = "$$(cat '$<')"
	$(DONE)
	$(call GITIGNORE_ADD,$@)

$(COMPOSER_VERSIONED_FILENAME): \
$(COMPOSER_INSTALLER_FILENAME)
	$(call STATUS,'Downloading Composer v$(COMPOSER_VERSION)')
	@php '$<' -- \
		--filename='$@' \
		--install-dir=./ \
		--version='$(COMPOSER_VERSION)' \
		> /dev/null
	$(DONE)
	$(call GITIGNORE_ADD,$(COMPOSER_FILENAME_PREFIX)*$(COMPOSER_FILENAME_SUFFIX))

ifneq ($(shell readlink $(COMPOSER_FILENAME)),$(COMPOSER_VERSIONED_FILENAME))
$(COMPOSER_FILENAME): \
$(COMPOSER_VERSIONED_FILENAME)
	$(call STATUS,'Installing Composer v$(COMPOSER_VERSION)')
	@ln -f -s '$<' '$@'
	$(DONE)
	$(call GITIGNORE_ADD,$@)
endif

composer-validate: \
composer-validate-pre \
.composer-validate \
composer-validate-post

composer-validate-pre:: ;

composer-validate-post:: ;

.composer-validate: \
$(COMPOSER_FILENAME) \
composer.json
	@php '$<' validate

composer-install: \
composer-install-pre \
.composer-install \
composer-install-post

composer-install-pre:: ;

composer-install-post:: ;

.composer-install: \
$(COMPOSER_FILENAME) \
composer.json
	@php '$<' install
	$(call GITIGNORE_ADD,$(shell php '$(COMPOSER_FILENAME)' config vendor-dir)/)

composer-clean:
	$(call STATUS,'Removing downloaded Composer files')
	@rm -f \
		'$(COMPOSER_FILENAME)' \
		'$(COMPOSER_INSTALLER_CHECKSUM_FILENAME)'
	$(DONE)

composer-distclean: \
composer-clean
	$(call STATUS,'Removing cached Composer files')
	@rm -f \
		'$(COMPOSER_INSTALLER_FILENAME)' \
		'$(COMPOSER_FILENAME_PREFIX)'*'$(COMPOSER_FILENAME_SUFFIX)'
	$(DONE)
