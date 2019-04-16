PWD := $(shell pwd)
GIT_COMMIT:=$(shell git rev-parse --verify HEAD --short=7)
CPU_JOBS=$(shell grep -c ^processor /proc/cpuinfo)
MACHINE=$(shell uname -m)
DESTDIR=
## @hostnamectl | grep "Chassis: vm" || echo "Not in a VM..." && exit 1

## Main Targets ##

.PHONY: clean
clean:
	@echo "Cleaning..."

.PHONY: install
install:
	install -m755 -D scripts/docker-build-with-tools $(DESTDIR)/sbin/docker-build-with-tools
