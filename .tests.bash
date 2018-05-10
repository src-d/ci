#!/bin/bash
set -xe

MAKE=make
if [[ ! -z ${APPVEYOR} ]]; then
	MAKE=mingw32-make
fi

EXAMPLES="examples/basic"

for example in ${EXAMPLES} ; do
	echo "Running $example"

	cp Makefile.main ${example}/Makefile.main
	pushd $example &> /dev/null

	"${MAKE}" dependencies

	"${MAKE}" test

	"${MAKE}" test-coverage

	"${MAKE}" packages

	popd &> /dev/null
done
