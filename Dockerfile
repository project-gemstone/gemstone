FROM ubuntu:disco

# We can set the git branch to get by using --build-arg when we use docker build.
ARG BRANCH=master

# Update and install packages.
RUN apt-get update && apt-get install make file curl wget git pigz -y && apt-get autoremove -y

# Pull repo and install scripts
RUN git clone https://github.com/project-gemstone/gemstone && cd /gemstone && git pull origin $BRANCH
WORKDIR /gemstone

# Make env file.
RUN make env-docker
RUN cat ./.bashrc > /root/.bashrc
RUN cat ./.bash_profile > /root/.bash_profile

# Change symlink for bash.
RUN cd /bin/ && rm sh && ln -s bash sh

RUN mkdir -p /work

RUN exit 0

# Install scripts.
RUN cd /gemstone && make install

# Install ports collection.
RUN cd /work && git clone https://github.com/project-gemstone/quary

# Download and extract toolchain.
RUN mkdir -p /work/tools
RUN cd /work/tools && wget -O tools.tar.gz https://github.com/project-gemstone/gemstone/releases/download/0.0.1/x86_64-project_gemstone-linux-gnu-20190416_150917.tar.gz
RUN cd /work/tools && tar -xf ./tools.tar.gz
RUN cd /work/tools && rm tools.tar.gz
RUN chown root:root -R /work/tools

# Create link to tools.
RUN ln -sv /work/tools /

# Sync everything.
RUN sync

WORKDIR /
RUN source /root/.bash_profile

ENTRYPOINT ["/sbin/build-pkgs-with-tools", "/work"]
