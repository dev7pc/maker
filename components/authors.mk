SHELL = /bin/bash

define AUTHORS
$(shell git config --get user.name) <$(shell git config --get user.email)>
endef
export AUTHORS
AUTHORS:
	@echo "$$AUTHORS" > '$@'
