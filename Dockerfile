FROM ubuntu:bionic

# We can set the git branch to get by using --build-arg when we use docker build.
ARG BRANCH=master
ARG TOOL_VER=0.0.1

# Update and install packages.
RUN apt-get update && apt-get install make file curl wget git -y && apt-get autoremove -y

# Pull repo and install scripts
RUN git clone https://github.com/project-gemstone/gemstone && cd /gemstone && git pull origin $BRANCH
WORKDIR /gemstone

RUN mkdir -p /work

# Install scripts.
RUN make install-scripts

# Install mkpkg configs.
RUN make install-conf DESTDIR=/work

# Install ports collection.
RUN cd /work && git clone https://github.com/project-gemstone/quary

# Download and extract toolchain.
RUN mkdir -p /work/tools
RUN cd /work/tools && wget -O tools.tar.gz https://github.com/project-gemstone/gemstone/releases/download/$TOOL_VER/x86_64-project_gemstone-linux-gnu.tar.gz
RUN cd /work/tools && tar -xf ./tools.tar.gz
RUN cd /work/tools && rm tools.tar.gz

# Create link to tools.
RUN ln -sv /work/tools /

# Sync everything.
RUN sync

WORKDIR /

ENTRYPOINT ["/sbin/docker-build-with-tools", "/work"]
