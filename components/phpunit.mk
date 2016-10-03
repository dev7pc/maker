SHELL = /bin/bash

PHPUNIT_VERSION ?= 5.5.5

.PHONY: \
phpunit-test phpunit-test-pre .phpunit-test phpunit-test-post

phpunit-test: phpunit-test-pre .phpunit-test phpunit-test-post
phpunit-test-pre:: ;
phpunit-test-post:: ;
.phpunit-test: composer-dependencies
	@php vendor/bin/phpunit --bootstrap=vendor/autoload.php _tests/
