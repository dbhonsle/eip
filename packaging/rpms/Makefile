ARCH=$(shell uname -m)

rhel8.1: buildtgz
	docker build \
	-t rpmbuild-$@/$(ARCH) \
	-f $@//Dockerfile \
	.
	mkdir -p rpmbuild/RPMS
	mkdir -p rpmbuild/SRPMS
	docker run --rm \
	-v $(CURDIR)/rpmbuild/SOURCES:/root/rpmbuild/SOURCES:ro \
	-v $(CURDIR)/rpmbuild/RPMS:/root/rpmbuild/RPMS \
	-v $(CURDIR)/rpmbuild/SRPMS:/root/rpmbuild/SRPMS \
	rpmbuild-$@/$(ARCH) \
	-ba SPECS/eip.spec

buildtgz: rpmbuild/SOURCES/eip-$(VERSION).tgz
# --exclude .git
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

rpm: rhel8.1


clean:
	rm -rf rpmbuild/

.PHONY: rhel8.1 buildtgz clean