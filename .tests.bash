#!/bin/bash -xe

EXAMPLES="examples/basic"

for example in ${EXAMPLES} ; do
	echo "Running $example"

	mkdir -p ${example}/.ci
	cp Makefile.main ${example}/.ci/
	pushd $example &> /dev/null

	make dependencies

	make test

	make test-coverage

	make packages

	popd &> /dev/null
done
