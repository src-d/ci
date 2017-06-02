# Default shell
SHELL := /bin/bash

# Config
DESTINATION ?= public
LANDING_PATH ?=
hugo_version := 0.21

# System
pwd := $(shell pwd)
os := Linux
arq := 64bit
ifneq ($(shell uname -s),Linux)
	$(error "**error Unexpected OS. STOP")
endif

# Tools
curl := curl -L
mkdir := mkdir -p
npm := npm
untar := tar -xf
untargz := tar -zxf
rename := mv
remove := rm -rf
hugo_exec = $(hugo_path)/hugo

## Lists all recipes
list:
	@grep '^##' Makefile -A 1

## Install dependencies
dependencies: hugo-dependencies import-commons npm-dependencies

## Builds hugo project compiling assets and hugo files
hugo-build:
	$(hugo_exec) --config=hugo.config.yaml --destination=$(DESTINATION)

hugo_path := $(pwd)/.hugo
hugo_zip_name := hugo_$(hugo_version)_$(os)-$(arq).tar.gz
# Updates hugo dependencies
hugo-dependencies:
	@if [[ ! -f $(hugo_exec) ]]; then \
		$(mkdir) $(hugo_path); \
		cd $(hugo_path); \
		$(curl) https://github.com/spf13/hugo/releases/download/v$(hugo_version)/$(hugo_zip_name) -o $(hugo_zip_name); \
		$(untargz) $(hugo_zip_name); \
	fi;

export_filename = $(shell pwd)/landing-common.tar
file_list_name = .list.gitignore
# Imports common stuff
import-commons:
	$(MAKE) -C $(LANDING_PATH) export-landing-commons \
		target=$(export_filename) \
		file_list_name=$(file_list_name)
	$(untar) $(export_filename)
	$(remove) $(export_filename)
	$(rename) $(file_list_name) .gitignore

# Prepares npm and run webpack to compile the assets
npm-dependencies:
	$(npm) install
	$(npm) run build
	$(remove) node_modules
