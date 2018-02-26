#------------------------------------------------
#
#	setup environment
#
#------------------------------------------------

export GOPATH:=$(realpath $(shell pwd)/../../../..)
TOP:=$(realpath $(shell pwd)/$(dir $(firstword $(MAKEFILE_LIST))))
PACKAGE:=$(subst $(GOPATH)/src/,,$(TOP))

#------------------------------------------------
#
#	standard rules
#
#------------------------------------------------

# The first target defined is the default if no target is
# specified on the command line.  Make sure this doesn't
# take too long to run, so that people will run it on every
# build.
.PHONY: fast
fast: build coverage-short lint-fast

# Also define the "full fat" rule that does everything
.PHONY: all build
all: build coverage lint-full

-include .go-make/make/batteries.mk
.go-make/make/%:
	git clone https://github.com/go-make/make.git $(dir $@)
	rm -rf $(dir $@)/.git

#------------------------------------------------
#
#	now to actually build stuff...
#
#------------------------------------------------

# The 'build' target is where you customise for your project.
# In this simple example, we'll just install

.PHONY: build
build: docker-build

.PHONY: $(DIR_OUT)/mkcertd
$(DIR_OUT)/mkcertd: vendor
	$(call PROMPT,Building $@)
	GOARCH=amd64 GOOS=linux CGO_ENABLED=0 $(GO) build $(INSTALL_FLAGS) -o $@

#------------------------------------------------
#
#	docker support
#
#------------------------------------------------

-include .go-make/docker/docker.mk
.go-make/docker/%:
	git clone https://github.com/go-make/docker.git $(dir $@)
	rm -rf $(dir $@)/.git

certs.pem:
	go run main.go init > $@

docker-build-mkcert: $(DIR_OUT)/mkcertd certs.pem
$(eval $(call DOCKER_BUILD,,,lukasa,mkcert))
