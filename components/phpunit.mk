SHELL = /bin/bash

PHPUNIT_VERSION ?= 5.5.6
TEST_DIR ?= _tests/

.PHONY: \
phpunit-test phpunit-test-pre .phpunit-test phpunit-test-post

phpunit-test: \
phpunit-test-pre \
.phpunit-test \
phpunit-test-post

phpunit-test-pre:: ;

phpunit-test-post:: ;

.phpunit-test: \
composer-install
	@php '$(COMPOSER_FILENAME)' exec phpunit -- \
		--bootstrap="$$(php '$(COMPOSER_FILENAME)' config vendor-dir)/autoload.php" \
		--colors=auto \
		--debug \
		'$(TEST_DIR)'
