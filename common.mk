ARCH=$(shell uname -m)
CHOWN:=docker run --rm -v $(CURDIR):/v -w /v alpine chown