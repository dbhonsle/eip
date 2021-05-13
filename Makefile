REPO_ROOT:=${CURDIR}
OUT_DIR=$(REPO_ROOT)/bin
CONTAINER_ENGINE := docker
GO ?= go

GIT_BRANCH ?= $(shell git rev-parse --abbrev-ref HEAD 2>/dev/null)
GIT_BRANCH_CLEAN ?= $(shell echo $(GIT_BRANCH) | sed -e "s/[^[:alnum:]]/-/g")
EIP_IMAGE := eip_dev$(if $(GIT_BRANCH_CLEAN),:$(GIT_BRANCH_CLEAN))
PROJECT := github.com/dbhonsle/eip-docker
BUILDTAGS ?= seccomp
COMMIT_NO ?= $(shell git rev-parse HEAD 2> /dev/null || true)
COMMIT ?= $(if $(shell git status --porcelain --untracked-files=no),"$(COMMIT_NO)-dirty","$(COMMIT_NO)")
VERSION := $(shell cat ./VERSION)
RPMS_DIR:=$(CURDIR)/packaging/rpms

################################################################################
# ============================== OPTIONS =======================================
# install tool
INSTALL?=install
# install will place binaries here, by default attempts to mimic go install
ifndef DESTDIR
INSTALL_DIR?=$(shell ./goinstalldir.sh)
else
INSTALL_DIR?=$(DESTDIR)/usr/bin
endif
# the output binary name, overridden when cross compiling
EIP_BINARY_NAME?=eip
#EIP_BUILD_FLAGS?=
ifeq ($(shell $(GO) env GOOS),linux)
	ifeq (,$(filter $(shell $(GO) env GOARCH),mips mipsle mips64 mips64le ppc64))
		ifeq (,$(findstring -race,$(EXTRA_FLAGS)))
			GO_BUILDMODE := "-buildmode=pie"
		endif
	endif
endif

ifeq ($(shell $(GO) env GOARCH),s390x)
	GO_CC := CC=gcc
endif

GO_BUILD := $(GO_CC) $(GO) build -trimpath $(MOD_VENDOR) $(GO_BUILDMODE) $(EXTRA_FLAGS) -tags "$(BUILDTAGS)" \
	-ldflags "-X main.gitCommit=$(COMMIT) -X main.version=$(VERSION) $(EXTRA_LDFLAGS)"
GO_BUILD_STATIC := $(GO_CC) CGO_ENABLED=1 $(GO) build -trimpath $(MOD_VENDOR) $(EXTRA_FLAGS) -tags "$(BUILDTAGS) netgo osusergo" \
	-ldflags "-w -extldflags -static -X main.gitCommit=$(COMMIT) -X main.version=$(VERSION) $(EXTRA_LDFLAGS)"

################################################################################
# ================================= Building ===================================
# standard "make" target -> builds

.DEFAULT: eip

all: build
# builds eip locally, outputs to $(OUT_DIR)
eip:
#	go build -v -o "$(OUT_DIR)/$(EIP_BINARY_NAME)" $(EIP_BUILD_FLAGS)
	$(GO_BUILD) -o "$(OUT_DIR)/$(EIP_BINARY_NAME)" .
# alias for building eip
build: eip

clean:
	contrib/build_rpm.sh
	rm -rf "$(OUT_DIR)/"
	$(MAKE) -C $(RPMS_DIR) clean

eipimage:
	$(CONTAINER_ENGINE) build $(CONTAINER_ENGINE_BUILD_FLAGS) -t $(EIP_IMAGE) .

# builds eip in a container, outputs to $(OUT_DIR)
dbuild: eipimage
	$(CONTAINER_ENGINE) run $(CONTAINER_ENGINE_RUN_FLAGS) \
		--privileged --rm \
		-v $(CURDIR):/go/src/$(PROJECT) \
		$(EIP_IMAGE) make clean all

cross: eipimage
	$(CONTAINER_ENGINE) run $(CONTAINER_ENGINE_RUN_FLAGS) \
		-e BUILDTAGS="$(BUILDTAGS)" --rm \
		-v $(CURDIR):/go/src/$(PROJECT) \
		$(EIP_IMAGE) make localcross

localcross:
	CGO_ENABLED=1 GOARCH=arm GOARM=6 CC=arm-linux-gnueabi-gcc $(GO_BUILD) -o "$(OUT_DIR)/eip-linux-armel" $(EIP_BUILD_FLAGS) .
	CGO_ENABLED=1 GOARCH=arm GOARM=7 CC=arm-linux-gnueabihf-gcc $(GO_BUILD) -o "$(OUT_DIR)/eip-linux-armhf" $(EIP_BUILD_FLAGS) .
	CGO_ENABLED=1 GOARCH=arm64 CC=aarch64-linux-gnu-gcc $(GO_BUILD) -o "$(OUT_DIR)/eip-linux-arm64" $(EIP_BUILD_FLAGS) .
	CGO_ENABLED=1 GOARCH=ppc64le CC=powerpc64le-linux-gnu-gcc $(GO_BUILD) -o "$(OUT_DIR)/eip-linux-powerpc64le" $(EIP_BUILD_FLAGS) .
	CGO_ENABLED=1 GOARCH=s390x CC=s390x-linux-gnu-gcc $(GO_BUILD) -o "$(OUT_DIR)/eip-linux-s390x" $(EIP_BUILD_FLAGS) .

rpm: ## build rpm packages
	$(MAKE) GIT_BRANCH=$(GIT_BRANCH) GIT_BRANCH_CLEAN=$(GIT_BRANCH_CLEAN) COMMIT_NO=$(COMMIT_NO) COMMIT=$(COMMIT) VERSION=$(VERSION) -C $(RPMS_DIR) rpm

install:
#        mkdir -p $(DESTDIR)/usr/bin
#        install -m 0755 cello $(DESTDIR)/usr/bin/cello
	$(INSTALL) -d $(INSTALL_DIR)
	$(INSTALL) "$(OUT_DIR)/$(EIP_BINARY_NAME)" "$(INSTALL_DIR)/$(EIP_BINARY_NAME)"

#################################################################################
.PHONY: all eip build install clean eipimage dbuild rpm