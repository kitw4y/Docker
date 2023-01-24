# Base Image: Ubuntu
FROM ubuntu:latest

# Env
ENV DEBIAN_FRONTEND noninteractive
ENV USER Orkun
ENV HOSTNAME Comp
ENV LC_ALL C
ENV USE_CCACHE 1
ENV CCACHE_SIZE 10G
ENV CCACHE_EXEC /usr/bin/ccache

# Working Directory
WORKDIR /tmp

# Maintainer
MAINTAINER orkunergun <hesaphesapyus@gmail.com>

# Install dependencies
RUN set -x \
    && apt-get -yqq update \
    && apt-get install --no-install-recommends -yqq \
    git-core gnupg flex bison build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z1-dev libgl1-mesa-dev libxml2-utils xsltproc unzip fontconfig \
    ca-certificates bc cpio imagemagick bsdmainutils python2 python-is-python3 lz4 aria2 ccache rclone ssh-client libncurses5 libssl-dev rsync schedtool sudo lld && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/apt/archives && \
    rm -rf /usr/share/doc/ /usr/share/man/ /usr/share/man/

# Install gh
RUN set -x \
    && curl -LO https://github.com/cli/cli/releases/download/v2.21.2/gh_2.21.2_linux_amd64.deb \
    && dpkg -i gh* \
    && rm gh*

# Create seperate build user
RUN groupadd -g 1000 -r ${USER} && \
    useradd -u 1000 --create-home -r -g ${USER} ${USER}

# Allow sudo without password for build user
RUN echo "${USER} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USER} && \
    usermod -aG sudo ${USER}

USER ${USER}

# Configure git
RUN git config --global user.name ${USER} && git config --global user.email ${USER}@${HOSTNAME} && \
    git config --global color.ui auto

# Install repo
RUN set -x \
    && curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo \
    && chmod a+x ~/bin/repo
RUN echo 'export PATH=~/bin:$PATH' > ~/.bashrc

# Run bash
VOLUME ["/tmp/ccache"]
ENTRYPOINT ["/bin/bash"]