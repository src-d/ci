#!/bin/bash
set -xe

MAKE=make
if [[ ! -z ${APPVEYOR} ]]; then
	MAKE=mingw32-make
fi

EXAMPLES="examples/basic"

for example in ${EXAMPLES} ; do
	echo "Running $example"

	mkdir -p ${example}/.ci
	cp Makefile.main ${example}/.ci/
	pushd $example &> /dev/null

	"${MAKE}" ci-install

	"${MAKE}" ci-script

	"${MAKE}" packages

	# Ensure we produce runnable binaries on current platform
	for b in build/bin/* ; do
		"$b"
	done

	POSTGRESQL_VERSION=9.6 RABBITMQ_VERSION=any "${MAKE}" prepare-services

	popd &> /dev/null
done
