REPO_ROOT:=${CURDIR}
OUT_DIR=$(REPO_ROOT)/bin
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
EIP_BUILD_FLAGS?=

################################################################################
# ================================= Building ===================================
# standard "make" target -> builds
all: build
# builds eip in a container, outputs to $(OUT_DIR)
eip:
	go build -v -o "$(OUT_DIR)/$(EIP_BINARY_NAME)" $(EIP_BUILD_FLAGS)
# alias for building eip
build: eip

clean:
	rm -rf "$(OUT_DIR)/"

install:
#        mkdir -p $(DESTDIR)/usr/bin
#        install -m 0755 cello $(DESTDIR)/usr/bin/cello
	$(INSTALL) -d $(INSTALL_DIR)
	$(INSTALL) "$(OUT_DIR)/$(EIP_BINARY_NAME)" "$(INSTALL_DIR)/$(EIP_BINARY_NAME)"

#################################################################################
.PHONY: all eip build install clean