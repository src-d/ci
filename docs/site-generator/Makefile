# Default shell
SHELL := /bin/sh

# Config
SHARED ?= /etc/shared
SOURCES ?=
OUTPUT ?=
export BASEURL ?=
export OWNER ?= src-d
export REPOSITORY ?=
export VERSION ?=
export LANGUAGES ?=

# Variables
landing_path := $(SHARED)/landing
site_sources_path := $(SOURCES)/.doc-site-sources
hugo_template_path = ./hugo-template
makefile_templates_paths = ./makefile-templates

# Tools
copy = cp -R
remove = rm -rf
move = mv -f
mkdir = mkdir -p

## Lists all recipes
list:
	@grep '^##' Makefile -A 1

## Generates a documentation-site based in sourced-landing for the required project
docs: copy-sources extract-repo-documentation site-build clean-up

## Generates a landing-like site for serving 404 and 500 errors
error-site: copy-sources site-build clean-up

# Copies the hugo template into the site sources folder
copy-sources:
	$(mkdir) $(site_sources_path)
	$(remove) $(site_sources_path)
	$(copy) $(hugo_template_path) $(site_sources_path)

hugo_content_raw_path = $(site_sources_path)/hugo/content/raw
project_yml_path = $(site_sources_path)/hugo/data
# Extracts the documentation contents from the project repository
extract-repo-documentation:
	$(copy) $(SOURCES)/README.md $(hugo_content_raw_path)

	$(copy) $(SOURCES)/LICENSE $(hugo_content_raw_path)

	@if [ -d $(SOURCES)/_examples ]; then \
		$(copy) $(SOURCES)/_examples/* $(hugo_content_raw_path)/examples/; \
	fi;

	@if [ -d $(SOURCES)/_tutorials ]; then \
		$(copy) $(SOURCES)/_tutorials/* $(hugo_content_raw_path)/tutorials/; \
	fi;

	@if [ -d $(SOURCES)/_downloads ]; then \
		$(copy) $(SOURCES)/_downloads/* $(hugo_content_raw_path)/downloads/; \
	fi;

	@envsubst < $(makefile_templates_paths)/project.yml > $(project_yml_path)/project.yml

generated_site_path=$(site_sources_path)/public
# Builds the documentation-site
site-build:
	$(MAKE) -C $(site_sources_path) hugo-build DESTINATION=$(generated_site_path)
	$(mkdir) $(OUTPUT)
	$(move) $(generated_site_path)/* $(OUTPUT)

# Cleans up
clean-up:
	$(remove) $(site_sources_path)
