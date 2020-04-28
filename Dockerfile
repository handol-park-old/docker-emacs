FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install -y \
        autoconf \
        automake \
        autotools-dev \
        build-essential \
        curl \
        dpkg-dev \
        git \
        gnupg \
        imagemagick \
        ispell \
        libacl1-dev \
        libasound2-dev \
        libcanberra-gtk3-module \
        liblcms2-dev \
        libdbus-1-dev \
        libgif-dev \
        libgnutls28-dev \
        libgpm-dev \
        libgtk-3-dev \
        libjansson-dev \
        libjpeg-dev \
        liblockfile-dev \
        libm17n-dev \
        libmagick++-6.q16-dev \
        libncurses5-dev \
        libotf-dev \
        libpng-dev \
        librsvg2-dev \
        libselinux1-dev \
        libtiff-dev \
        libxaw7-dev \
        libxml2-dev \
        openssh-client \
        python \
        texinfo \
        xaw3dg-dev \
        zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

ENV EMACS_BRANCH="emacs-26.3"
ENV EMACS_VERSION="26.3"

COPY source /opt/emacs

RUN cd /opt/emacs && \
    ./autogen.sh && \
    ./configure --with-modules && \
    make -j 8 && \
    make install

RUN mkdir -p /root/.emacs.d/elpa/gnupg && \
    chmod 700 /root/.emacs.d/elpa/gnupg && \
    gpg --homedir /root/.emacs.d/elpa/gnupg \
        --keyserver hkp://ipv4.pool.sks-keyservers.net \
        --recv-keys 066DAFCB81E42C40

RUN curl -fsSL https://raw.githubusercontent.com/cask/cask/master/go | python
ENV PATH="/root/.cask/bin:$PATH"

CMD ["emacs"]
