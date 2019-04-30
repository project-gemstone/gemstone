FROM debian:8

# We can set the git branch to get by using --build-arg when we use docker build.
ARG BRANCH=master

# Change symlink for bash.
RUN cd /bin && rm sh && ln -s bash sh

# Update and install packages.
RUN apt-get update && apt-get install make file curl wget git pigz sudo build-essential bison file gawk texinfo -y && apt-get autoremove -y
RUN rm -rf /var/lib/apt/lists/*

# Pull repo and install scripts
RUN git clone --single-branch --branch $BRANCH https://github.com/project-gemstone/gemstone
WORKDIR /gemstone

# create lfs user with 'lfs' password
RUN groupadd worker
RUN useradd -u 8877 -s /bin/bash -g worker -m -k /dev/null worker 
RUN echo "worker:worker" | chpasswd
RUN adduser worker sudo
RUN echo "worker ALL = NOPASSWD : ALL" >> /etc/sudoers
#RUN echo 'Defaults env_keep += "WORK TOOLS SOURCES LOGS_DIR TOOLS_TGT PATH MAKEFLAGS"' >> /etc/sudoers

# Make env file for root and worker
RUN make env-docker
RUN cp /gemstone/.bashrc /root/.bashrc
RUN cp /gemstone/.bashrc /home/worker/.bashrc
RUN cp /gemstone/.bash_profile /root/.bash_profile
RUN cp /gemstone/.bash_profile /home/worker/.bash_profile
RUN chown worker -R /home/worker/

# Make work dir.
RUN mkdir -p /work

# Install scripts.
RUN cd /gemstone && make install

# Install ports collection.
RUN cd /work && git clone https://github.com/project-gemstone/quary

# Download and extract toolchain.
RUN mkdir -p /work/tools
RUN cd /work/tools && wget -O tools.tar.gz https://github.com/project-gemstone/gemstone/releases/download/0.0.1/x86_64-project_gemstone-linux-gnu-20190416_150917.tar.gz
RUN cd /work/tools && tar -xf ./tools.tar.gz
RUN cd /work/tools && rm tools.tar.gz
RUN chown worker -R /work

# Create link to tools.
RUN ln -sv /work/tools /

# Sync everything.
RUN sync

# Run as worker user.
USER worker
WORKDIR /
RUN source /home/worker/.bash_profile
ENV LC_ALL=POSIX
ENV PATH=/tools/bin:/bin:/usr/bin
ENV MAKEFLAGS="-j1"

ENTRYPOINT ["/sbin/docker-entry"]
