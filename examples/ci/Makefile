# Package configuration
PROJECT = ci
COMMANDS = cmd/test
#CODECOV_TOKEN = your codecov token

# Including ci Makefile
MAKEFILE = Makefile.main
CI_REPOSITORY = https://github.com/src-d/ci.git
CI_FOLDER = .ci

# If you need to build more than one dockerfile, you can do so like this:
# DOCKERFILES = Dockerfile_filename1:repositoryname1 Dockerfile_filename2:repositoryname2 ...

$(MAKEFILE):
	@git clone --quiet $(CI_REPOSITORY) $(CI_FOLDER); \
	cp $(CI_FOLDER)/$(MAKEFILE) .;

-include $(MAKEFILE)
