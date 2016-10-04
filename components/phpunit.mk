SHELL = /bin/bash

PHPUNIT_VERSION ?= 5.5.6
TEST_DIR ?= _tests/

.PHONY: \
phpunit-test phpunit-test-pre .phpunit-test phpunit-test-post

phpunit-test: phpunit-test-pre .phpunit-test phpunit-test-post
phpunit-test-pre:: ;
phpunit-test-post:: ;
.phpunit-test: composer-install
	@php vendor/bin/phpunit --bootstrap=vendor/autoload.php '$(TEST_DIR)'
