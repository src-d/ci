# source{d} CI

This project contains the common CI configuration for all source{d} Go projects, including the following functionalities:

* Automatic docker image upload on tag. It will upload the image to `$(DOCKER_ORG)/$(PROJECT)` on the given `DOCKER_REGISTRY`.
* Automatic upload of built binaries to GitHub releases on tag.
* Tests with coverage (using codecov.io).

Right now, this has only been tested with TravisCI.

- [Makefile.main](https://github.com/src-d/ci/tree/master/examples/Makefile.main): a common Makefile that should be included in all source{d}'s Go projects. Just set up some variables:
  - **PROJECT**: the project's name (mandatory).
  - **COMMANDS**: packages and subpackages to be compiled as binaries (mandatory).
  - **DOCKERFILES**: dockerfiles presents in the project (optional).

- [.travis.yml](https://github.com/src-d/ci/tree/master/examples/.travis.yml): config file used by TravisCI to create the build and such. Ideally, it's just necessary to specify the CODECOV_TOKEN and the proper project's name under the deploy section.

Use the files under [examples](https://github.com/src-d/ci/tree/master/examples) as a template.

You will need to configure the following environment variables and make them available during the build process:

* `DOCKER_ORG`: docker organisation name.
* `DOCKER_EMAIL`: email of the registry account.
* `DOCKER_USERNAME`: username of the registry account.
* `DOCKER_PASSWORD`: password of the registry account.
* `DOCKER_REGISTRY`: docker registry where images will be pushed.

Also, for publishing to GitHub, you will need to provide a GitHub API key.

For that, in travis, you can use the `env`. If your project is public, make sure to use [secrets](https://docs.travis-ci.com/user/encryption-keys/).
