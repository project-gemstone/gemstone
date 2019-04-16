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
* BUILDPKG packaging format - `Archlinux / Alpine Linux`
* From scratch base - `Linux From Scratch / Void Linux / Venom Linux`

## Files in this repo

* `Dockerfile` - Dockerfile used to build `base` packages in the `quary` repository using the prebuilt toolchain which was generated using `mktools`.
* `scripts/docker-build-with-tools` - Entrypoint script used by the `Dockerfile` to build each package in a certain order.


