#!/usr/bin/make -f
mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := packaging/$(notdir $(patsubst %/,%,$(dir $(mkfile_path))))
outdir := $(CURDIR)
topdir := $(CURDIR)/rpmbuild
#SHORT_COMMIT ?= $(shell git rev-parse --short=8 HEAD)
VERSION := $(shell cat ./VERSION)
BUILDREQUIRES_GO := 1

export GO111MODULE=on

srpm:
	mkdir -p $(topdir)
	sh $(current_dir)/prepare.sh
	rpmbuild -bs -D "dist %{nil}" -D "_sourcedir build/" -D "_srcrpmdir $(outdir)" -D "_topdir $(topdir)" -D "_version $(VERSION)" -D "_buildrequires_go $(BUILDREQUIRES_GO)" --nodeps ${extra_arg:-""} packaging/rpms/SPECS/eip.spec

build_binary:
	mkdir -p $(topdir)
#	rpmbuild --rebuild -D "_rpmdir $(outdir)" -D "_topdir $(topdir)" ${extra_arg:-""} $(outdir)/podman-*.git$(SHORT_COMMIT).src.rpm
	rpmbuild --rebuild -D "_rpmdir $(outdir)" -D "_topdir $(topdir)" -D "_version $(VERSION)" -D "_buildrequires_go $(BUILDREQUIRES_GO)" ${extra_arg:-""} $(outdir)/eip-$(VERSION).src.rpm

clean:
	rm -fr rpms