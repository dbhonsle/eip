ARCH=$(shell uname -m)

opensuse-leap: build-git-tgz
	docker build \
	-t rpmbuild-$@/$(ARCH) \
	-f $@/Dockerfile \
	.
	mkdir -p rpmbuild/RPMS
	mkdir -p rpmbuild/SRPMS
	docker run --rm \
	-v $(CURDIR)/rpmbuild/SOURCES:/root/rpmbuild/SOURCES:ro \
	-v $(CURDIR)/rpmbuild/RPMS:/root/rpmbuild/RPMS \
	-v $(CURDIR)/rpmbuild/SRPMS:/root/rpmbuild/SRPMS \
	rpmbuild-$@/$(ARCH) \
	-ba \
	--define '_version $(VERSION)' \
	SPECS/eip.spec

buildtgz: rpmbuild/SOURCES/eip-$(VERSION).tgz

rpmbuild/SOURCES/eip-$(VERSION).tgz:
	rm -rf $(@D)
	$(eval TMPDIR := $(shell mktemp -d))
	docker run --rm -w /v \
		-v $(realpath $(CURDIR)/../../):/eip-$(VERSION) \
		-v $(TMPDIR):/v \
		alpine \
		tar -C / -c -z -f /v/eip-$(VERSION).tgz eip-$(VERSION)
	mkdir -p $(@D)
	cp $(TMPDIR)/eip-$(VERSION).tgz $(@D)/
	rm -rf $(TMPDIR)

rpm: opensuse-leap

build-git-tgz:
	mkdir -p rpmbuild/SOURCES
	$(shell git archive --prefix "eip-$(VERSION)/" --format "tgz" HEAD -o "rpmbuild/SOURCES/eip-$(VERSION).tgz")

clean:
	rm -rf rpmbuild/

.PHONY: opensuse-leap buildtgz clean build-git-tgz