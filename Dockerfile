FROM ubuntu:disco

# We can set the git branch to get by using --build-arg when we use docker build.
ARG BRANCH=master

# Update and install packages.
RUN apt-get update && apt-get install make file curl wget git pigz sudo -y && apt-get autoremove -y

# Pull repo and install scripts
RUN git clone --single-branch --branch $BRANCH https://github.com/project-gemstone/gemstone
WORKDIR /gemstone

# Make env file for root.
RUN make env-docker
RUN cat ./.bashrc > /root/.bashrc

# create lfs user with 'lfs' password
RUN groupadd worker
RUN useradd -s /bin/bash -g worker -m -k /dev/null worker 
RUN echo "worker:worker" | chpasswd
RUN adduser worker sudo

# Copy bashrc and bash_profile for worker.
RUN cp /gemstone/.bashrc /home/worker/.bashrc
RUN cp /gemstone/.bash_profile /home/worker/.bash_profile
RUN chown worker:worker -R /home/worker/*

RUN echo "worker ALL = NOPASSWD : ALL" >> /etc/sudoers
RUN echo 'Defaults env_keep += "TOOLS SOURCES LOGS_DIR TOOLS_TGT PATH MAKEFLAGS"' >> /etc/sudoers

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
RUN chown worker:worker -R /work/tools

# Create link to tools.
RUN ln -sv /work/tools /
RUN chown worker:worker -R /tools

# Change ownership
RUN chown worker:worker -R /work

# Sync everything.
RUN sync

# Run as worker user.
USER worker
WORKDIR /
RUN source ~/.bash_profile

ENTRYPOINT ["/sbin/docker-build-with-tools", "/work"]
