# source{d} CI

This project contains the common CI configuration for all source{d} Go projects, including the following functionalities:

* Automatic docker image upload on tag. It will upload the image to `$(DOCKER_ORG)/$(PROJECT)` on the given `DOCKER_REGISTRY`.
* Automatic upload of built binaries to GitHub releases on tag.
* Tests with coverage (using codecov.io).

It supports Travis CI (Linux and macOS) and Appveyor (Windows).

- [Makefile](https://github.com/src-d/ci/tree/v1/examples/basic/Makefile): a common Makefile that should be included in all source{d}'s Go projects. Just set up some variables:
  - **PROJECT**: the project's name (mandatory).
  - **COMMANDS**: packages and subpackages to be compiled as binaries (mandatory).
  - **DOCKERFILES**: dockerfiles presents in the project (optional).

- [.travis.yml](https://github.com/src-d/ci/tree/v1/examples/basic/.travis.yml): config file used by Travis CI to create the build the project.

Use the files under [examples](https://github.com/src-d/ci/tree/v1/examples/basic) as a template.

In order to publish Docker images, you will need to configure the following environment variables and make them available during the build process:

* `DOCKER_USERNAME`: username of the registry account.
* `DOCKER_PASSWORD`: password of the registry account.

And optionally:

* `DOCKER_ORG`: docker organisation name (defaults to `srcd`).
* `DOCKER_REGISTRY`: docker registry where images will be pushed (defaults to Docker Hub).

Also, for publishing to GitHub, you will need to provide a GitHub API token in the `GITHUB_TOKEN` environment variable. If your project is public, make sure that the variable is marked as not visible.

**NOTE to source{d} developers: request Docker and GitHub token setup to the Infrastructure Team.**

## Tasks

### Main hooks

These rules are meant to be used as is on their corresponding CI phase:

* `ci-install` (for Travis and Appveyor `install` phase): runs `dependencies`.
* `ci-script` (for Travis `script` and Appveyor `test_script` phases): runs `test-coverage`, `codecov` and `packages`.

### Tests packages

There are thee rules available for testing:

* `test`: regular execution of the tests
* `test-race` : execute the tests with the race detector enabled
* `test-coverage`: execute the tests and get coverage. This rule generates a `coverage.txt` file that can be uploaded to codecov.io using the `codecov` rule.

### Building packages

The rule `packages` creates the distribution packages, containing the command
line utilities defined by the `COMMANDS` compiled for the architectures and
OS defined by `PKG_OS` and `PKG_ARCH`.

The package filename is follows the following pattern: `<project>_<version>_<os>_<arch>.tar.gz`

### Docker build and push

The `docker-build` rule builds the dockerfiles defined by `DOCKERFILES`. Several
dockerfiles may be define in a project eg.:

If we have an application with two different docker images, we can achieve this
by creating two different docker files called `Dockerfile.server` and
`Dockerfile.client`.

```
DOCKERFILES = Dockerfile.server:$(PROJECT)-server Dockerfile.client:$(PROJECT)-client
```

The `DOCKERFILES` variable should be defined as list of dockerfile-path:image-name
pairs, for example `Dockerfile:my-image`.

The rule `docker-push` builds and pushes to the defined registry all the defined
docker images. The images are tagged with the current value of `VERSION`. If
`DOCKER_PUSH_LATEST` is provided with any value, a `latest` tag is created and
pushed too.

To push `latest` tag automatically when the tag conforms a semantic
version (`v1.2.3`) you can either use `docker-push-latest-release` or the
variable `IS_RELEASE` in your makefile:

```makefile
release-docker:
  @DOCKER_PUSH_LATEST=$(IS_RELEASE) make docker-push
```

### External service setup

The `ci-install` rule sets up external services consistently across different CI providers
and operating systems. External services to setup are specified with environment variables:

* `POSTGRESQL_VERSION`: if not empty, PostgreSQL will be installed or started. Check supported versions on
   [Travis CI](https://docs.travis-ci.com/user/database-setup/#Using-a-different-PostgreSQL-Version),
   [Appveyor](https://www.appveyor.com/docs/services-databases/#postgresql) and [Homebrew](http://formulae.brew.sh/formula/). Currently `9.4`, `9.5` and `9.6` are supported across all of them.
* `RABBITMQ_VERSION`, if not empty, RabbitMQ will be installed or started. Currently `any` is the only supported value.

[Check all supported services and versions.](https://github.com/smola/ci-tricks/#tricks)

## Notes

### Version calculation

The `VERSION` variable is calculated based on the current git commit, plus a
`-dirty` flag, if the worktree isn't clean. Example: `dev-01eda91-dirty`. If the
environment is Travis, the `TRAVIS_BRANCH` is used as `VERSION`. The variable is
set if it wasn't set previously.

### Writing your Dockerfiles

When writing your `Dockerfiles` you can find the compiled binaries at
`$(BUILD_PATH)/bin` directory. E.g.: `ADD build/bin /bin`

### Custom build parameters

The `go build` commands supports several variables, which are easily
customizable to cover edge cases of complex builds.

* `LD_FLAGS`: used to define the LD_FLAGS provided to the go compiler it's preconfigured with some build info variables. Eg.: `LG_FLAGS += -extldflags "-static" -s -w`
* `GO_TAGS`: Tags to be used as `-tags` argument at `go build` and `go install`
* `GO_BUILD_ENV`: Envariamble variables used at the `go build` execution . E.g.: `GO_BUILD_ENV = CGO_ENABLED=0`

### Rule `no-changes-in-commit`

The `no-changes-in-commit` rule checks if not ignored files in the repository have changed or have been added.
Useful to detect non-commited generated code for projects based on `go generate`, `gobindata` or `dep ensure`.

`dep ensure` can be executed with rule `godep`. It downloads the latest version of the tool and executes it.

Example:

```shell
validate-commit: dependencies generate-assets no-changes-in-commit

dependencies: godep

generate-assets:
  yarn build
  go-bindata dist
```
