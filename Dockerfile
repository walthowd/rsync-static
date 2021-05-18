FROM ubuntu:focal AS rsync

# Set to targeted rsync version
ENV RSYNC=rsync-3.2.3

# Setup build environment
ENV DEBIAN_FRONTEND=noninteractive
RUN sed -i 's/^#.deb-src/deb-src/g' /etc/apt/sources.list;\
    apt update;\
    apt-get -fqqy install dpkg-dev; \
    apt-get -fqqy build-dep rsync; \
    apt-get -fqqy install wget gcc g++ gawk autoconf automake python3-cmarkgfm ;\
    apt-get -fqqy install acl liblz4-dev libacl1-dev attr libattr1-dev libxxhash-dev libzstd-dev libssl-dev;

# Build rsync from source
RUN mkdir -p /src; cd /src; \
    wget https://download.samba.org/pub/rsync/src/$RSYNC.tar.gz; \
    tar zxf $RSYNC.tar.gz && cd $RSYNC; \
    ./configure CFLAGS="-static"; \
    make && make install;

FROM alpine:3.13
COPY --from=rsync /usr/local/bin/rsync /usr/bin/rsync
