# list of languages to build the documentation for
# example: LANGUAGES = python cpp
LANGUAGES = python
# destination output of the built docs
DESTINATION_FOLDER ?= ./output
# name of the version docs being built
VERSION_NAME ?= $(git name-rev --tags --name-only `git rev-parse HEAD`)
# repository name
REPOSITORY ?= "repo_name"
# user or organization who owns the repository
REPOSITORY_OWNER ?= "src-d"
# specify main directory of python source code files
# can be omitted if the directory is `src`
PYTHON_MAIN_DIR = .

# do not edit this
SHARED_FOLDER ?= $(PWD)/.shared
MAKEFILE = Makefile.docs
CI_REPO = https://github.com/src-d/ci.git

$(MAKEFILE):
	@if [ -z "$(DOCSRV)" ]; then \
		if [ ! -d "$(SHARED_FOLDER)" ]; then \
			mkdir -p "$(SHARED_FOLDER)"; \
		fi; \
		if [ ! -d "$(SHARED_FOLDER)/ci" ]; then \
			git clone "$(CI_REPO)" "$(SHARED_FOLDER)/ci"; \
		fi; \
	fi; \
	cp "$(SHARED_FOLDER)/ci/Makefile.docs" .;

-include $(MAKEFILE)
