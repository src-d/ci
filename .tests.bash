#!/bin/bash -xe

EXAMPLES=examples/ci

for example in ${EXAMPLES} ; do
	echo "Running $example"

	cp Makefile.main ${example}/Makefile.main
	pushd $example &> /dev/null

	make test

	make test-coverage

	make packages

	popd &> /dev/null
done
