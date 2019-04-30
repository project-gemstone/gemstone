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
	install -m755 -D scripts/build-pkgs-with-tools $(DESTDIR)/sbin/build-pkgs-with-tools
	
env-docker:
	echo "set +h" > .bashrc
	echo "umask 022" >> .bashrc
	echo "LC_ALL=POSIX" >> .bashrc
	echo "WORK=/work" >> .bashrc
	echo "TOOLS=/work/tools" >> .bashrc
	echo "SOURCES=/work/sources" >> .bashrc
	echo "LOGS_DIR=/work/logs" >> .bashrc
	echo "TOOLS_TGT=x86_64-project_gemstone-linux-gnu" >> .bashrc
	echo "PATH=/tools/bin:/bin:/usr/bin:/sbin:/usr/sbin" >> .bashrc
	echo "MAKEFLAGS="-j1"" >> .bashrc
	echo "export LC_ALL WORK TOOLS SOURCES LOGS_DIR TOOLS_TGT PATH MAKEFLAGS" >> .bashrc
	echo "exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash" > .bash_profile
