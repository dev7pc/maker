SHELL = /bin/bash

GITIGNORE_FILENAME = .gitignore

GITIGNORE_ADD = @$$((cat '$(GITIGNORE_FILENAME)' 2> /dev/null; echo '/$1') | sort -u -o '$(GITIGNORE_FILENAME)')
