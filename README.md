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
* `DOCKER_USERNAME`: username of the registry account.
* `DOCKER_PASSWORD`: password of the registry account.
* `DOCKER_REGISTRY`: docker registry where images will be pushed.

Also, for publishing to GitHub, you will need to provide a GitHub API key.

For that, in travis, you can use the `env`. If your project is public, make sure to use [secrets](https://docs.travis-ci.com/user/encryption-keys/).

## Tasks

### Tests packages

Three rules are available `test` plain execution of test, `test-race` execute
the test with the `-race` flag and `test-coverage` it runs the tests with
coverage support and generate the `coverage.txt` file. The coverage file can
be uploaded to codecov using the rule `codecov`.

### Building packages

The rule `packages` creates the distribution packages, containing the command
line utilities defined by the `COMMANDS` compiled for the architectures and
OS, define by `PKG_OS` and `PKG_ARCH`.

The package filename is based on the pattern: `<project>_<version>_<os>_<arch>.tar.gz`

### Docker build and push

The rule `docker-build` builds the defined dockerfiles by `DOCKERFILES`. Several
dockerfile may be define per project eg.:

If we have an application with two different docker images, can be archived
creating two different docker files one call `Dockerfile.server` and
`Dockerfile.client`.

```
DOCKERFILES = Dockerfile.server:$(PROJECT)-server Dockerfile.client:$(PROJECT)-client
```

The `DOCKERFILES` variable should be defined as list of pairs file/name, example `Dockerfile:my-image`

The rule `docker-push` build and push the defined dockerimages. The images are
taggect with the current value of `VERSION`. If `DOCKER_PUST_LATEST` the `latest`
tag is created and pushed too.

## Notes

### Version calculation

The `VERSION` variable is calculated based on the current git commit, plus a
`-dirty` flag, if the worktree isn't clean. Example: `dev-01eda91-dirty`. If the
environment is Travis, the `TRAVIS_BRANCH` is used as `VERSION`. The variable is
set if wasn't set previously.

### Writing your Dockerfiles

When writing your `Dockerfiles` you can find the compiled binaries at the
`$(BUILD_PATH)/bin` path. Eg.: `ADD build/bin /bin`

### Custom build parameters

The `go build` command is supported by a group of variable, this variables are
easily customizable to cover edge cases of complex builds.

* `LD_FLAGS`: used to define the LD_FLAGS to be provide to the go compiler it-s preconfigure with some build infor variables. Eg.: `LG_FLAGS += -extldflags "-static" -s -w`
* `GO_TAGS`: Tags to be used as `-tags` argument at `go build` and `go install`
* `GO_BUILD_ENV`: Envariamble variables used at the `go build` execution . Eg.: `GO_BUILD_ENV = CGO_ENABLED=0`

### Rule `no-changes-in-commit`

The `no-changes-in-commit` rule checks if files in a repository have changed.
Useful to detect no commited generated code for projects based on `go generate`
or `gobindata`.

Example:

```
validate-commit: generate-assets no-changes-in-commit

generate-assets:
  yarn build
  go-bindata dist
```
