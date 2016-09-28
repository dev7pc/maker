SHELL = /bin/bash

define CHANGELOG_MD
Change Log
==========

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning v2.0.*](http://semver.org/spec/v2.0.0.html).

0.1.0 - $(shell date -u +%Y-%m-%d)
------------------
### Added
- Initial release
endef
export CHANGELOG_MD
CHANGELOG.md:
	@echo "$$CHANGELOG_MD" > '$@'
