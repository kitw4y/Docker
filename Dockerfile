FROM ubuntu:latest
LABEL maintainer="orkunergun <hesaphesapyus@gmail.com>"
ENV DEBIAN_FRONTEND noninteractive

WORKDIR /tmp

RUN apt-get -yqq update \
    && apt-get install --no-install-recommends -yqq adb autoconf automake axel bc bison build-essential clang cmake curl expat expect fastboot flex g++ g++-multilib gawk gcc gcc-multilib gcc-10 g++-10 g++-10-multilib git-core gnupg gperf htop imagemagick locales libncurses5 lib32ncurses5-dev lib32z1-dev libtinfo5 libc6-dev libcap-dev libexpat1-dev libgmp-dev '^liblz4-.*' '^liblzma.*' libmpc-dev libmpfr-dev libncurses5-dev libnl-route-3-dev libprotobuf-dev libsdl1.2-dev libssl-dev libtool libxml-simple-perl libxml2 libxml2-utils lld lsb-core lzip '^lzma.*' lzop maven nano ncftp ncurses-dev openssh-server patch patchelf pkg-config pngcrush pngquant protobuf-compiler python2.7 python3-apt python-all-dev python-is-python3 re2c rsync schedtool screen squashfs-tools subversion sudo tar texinfo tmate tzdata unzip w3m wget xsltproc zip zlib1g-dev zram-config \
    && curl --create-dirs -L -o /usr/local/bin/repo -O -L https://raw.githubusercontent.com/geopd/git-repo/main/repo \
    && chmod a+rx /usr/local/bin/repo \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* \
    && echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen && /usr/sbin/locale-gen \
    && TZ=Europe/Istanbul\
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN git clone https://github.com/mirror/make \
    && cd make && ./bootstrap && ./configure && make CFLAGS="-O3 -Wno-error" \
    && sudo install ./make /usr/bin/make

RUN curl -O https://downloads.rclone.org/rclone-current-linux-amd64.zip \
    && unzip rclone-current-linux-amd64.zip && cd rclone-*-linux-amd64 \
    && sudo cp rclone /usr/bin/ && sudo chown root:root /usr/bin/rclone \
    && sudo chmod 755 /usr/bin/rclone

RUN git clone https://github.com/ccache/ccache.git && cd ccache && git reset --hard 8c2da59 \
    && mkdir build && cd build && export CC=gcc-10 CXX=g++-10 && cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release .. \
    && make CFLAGS="-O3" && sudo make install

VOLUME ["/tmp/ccache", "/tmp/rom"]
ENTRYPOINT ["/bin/bash"]