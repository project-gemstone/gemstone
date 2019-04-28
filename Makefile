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
	
env-docker:
	echo "set +h" > .bashrc
	echo "umask 022" >> .bashrc
	echo "WORK=/work" >> .bashrc
	echo "TOOLS=$WORK/tools" >> .bashrc
	echo "SOURCES=$WORK/sources" >> .bashrc
	echo "LOGS_DIR=$WORK/logs" >> .bashrc
	echo "TOOLS_TGT=$(uname -m)-project_gemstone-linux-gnu" >> .bashrc
	echo "PATH=/tools/bin:/bin:/usr/bin" >> .bashrc
	echo "TOOLS_STEPS_DIR=$(pwd)/tools" >> .bashrc
	echo "MAKEFLAGS="-j1"" >> .bashrc
	echo "export TOOLS SOURCES LOGS_DIR TOOLS_TGT PATH TOOLS_STEPS_DIR MAKEFLAGS" >> .bashrc
