FROM ubuntu:latest
LABEL maintainer="orkunergun <hesaphesapyus@gmail.com>"
ENV DEBIAN_FRONTEND noninteractive

WORKDIR /tmp

RUN apt-get -yqq update \
    && apt-get install --no-install-recommends -yqq adb autoconf automake apt-transport-https aria2 axel bc bison build-essential ca-certificates ccache clang cmake curl expat expect fastboot flex g++ g++-multilib gawk gcc gcc-multilib gcc-10 g++-10 g++-10-multilib git-core gnupg gperf htop imagemagick locales libncurses5 lib32ncurses5-dev lib32z1-dev libtinfo5 libc6-dev libcap-dev libexpat1-dev libgmp-dev '^liblz4-.*' '^liblzma.*' libmpc-dev libmpfr-dev libncurses5-dev libnl-route-3-dev libprotobuf-dev libsdl1.2-dev libssl-dev libtool libxml-simple-perl libxml2 libxml2-utils lld lsb-core lzip '^lzma.*' lzop maven nano ncftp ncurses-dev openssh-server patch patchelf pigz pkg-config pngcrush pngquant protobuf-compiler python2.7 python3-apt python-all-dev python-is-python3 rclone re2c rsync schedtool screen squashfs-tools subversion sudo tar texinfo tmate tzdata unzip w3m wget xsltproc zip zlib1g-dev zram-config zstd \
    && curl --create-dirs -L -o /usr/local/bin/repo -O -L https://raw.githubusercontent.com/geopd/git-repo/main/repo \
    && chmod a+rx /usr/local/bin/repo \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* \
    && echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen && /usr/sbin/locale-gen \
    && TZ=Europe/Istanbul\
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install gh
RUN set -x \
    && curl -LO https://github.com/cli/cli/releases/download/v2.22.1/gh_2.22.1_linux_amd64.deb \
    && dpkg -i gh* \
    && rm gh*

# Install Git-Lfs
RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash \
    && apt-get install git-lfs

VOLUME ["/tmp/ccache"]
ENTRYPOINT ["/bin/bash"]
