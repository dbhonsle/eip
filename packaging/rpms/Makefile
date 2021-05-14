include ../../common.mk

opensuse-leap: build.tar.gz
	DOCKER_BUILDKIT=1 \
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
	--define '_git_branch $(GIT_BRANCH)' \
	--define '_git_branch_clean $(GIT_BRANCH_CLEAN)' \
	--define '_commit_no $(COMMIT_NO)' \
	--define '_commit $(COMMIT)' \
	SPECS/eip.spec

build.tar.gz: rpmbuild/SOURCES/eip-$(VERSION).tar.gz

rpmbuild/SOURCES/eip-$(VERSION).tar.gz:
	rm -rf $(@D)
	$(eval TMPDIR := $(shell mktemp -d))
	docker run --rm -w /v \
		-v $(realpath $(CURDIR)/../../):/eip-$(VERSION) \
		-v $(TMPDIR):/v \
		alpine \
		tar -C / -c -z -f /v/eip-$(VERSION).tar.gz --exclude .git eip-$(VERSION)
	mkdir -p $(@D)
	cp $(TMPDIR)/eip-$(VERSION).tar.gz $(@D)/
	rm -rf $(TMPDIR)

rpm: opensuse-leap

clean:
	[ ! -d rpmbuild ] || $(CHOWN) -R $(shell id -u):$(shell id -g) rpmbuild
	rm -rf rpmbuild/

.PHONY: opensuse-leap build.tar.gz clean build-git-tgz