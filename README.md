<p align="center">
  <img alt="Project V Logo" src="https://raw.githubusercontent.com/junland/miniature-journey/master/images/logo_size_icon.jpg" />
</p>

# Project Gemstone
The journey starts here.

## What is it?
Project Gemstone is a project to create the next Linux operating system focusing on server, container, and distributed workloads. The project takes a few ideas / features from lots of Linux distributions out there in the wild and reuses them for server applications. Below is a few examples:

* Small footprint - `Alpine Linux`
* Modules (Group packages) and delta binaries - `Intel Clear Linux`
* A / B Backups - `Container Linux / CoreOS`
* CRUX style packaging format - `CRUX Linux`
* From scratch base - `Linux From Scratch / Void Linux / Venom Linux`

## Stages

Project Gemstone will follow a alternated `stages` convention from Gentoo Linux in which certain phases of bootstrapping and build the operating system are seperated in stages.

Stage 0: Build a basic GNU Toolchain.

Stage 1: Cross compile a chroot with basic tools. (make, gcc, binutils, etc)

Stage 2: Much like `stage 1` however this stage will contain packages to manage supervision and booting. (eudev, util-linux, init system, etc)

Stage 3: Stage contains a generated initramfs and kernel image. This stage will be ready to make a ISO or `.img` file for booting. 

## Files in this repo

* `Dockerfile` - Dockerfile used to build `base` packages in the `quary` repository using the prebuilt toolchain which was generated using `mktools`.
* `scripts/docker-build-with-tools` - Entrypoint script used by the `Dockerfile` to build each package in a certain order.


