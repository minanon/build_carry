FROM debian:latest

RUN apt update \
    && apt install -y gcc make patch curl xz-utils m4 pkg-config

RUN curl -L 'https://www.openssl.org/source/openssl-1.1.0b.tar.gz' | tar -zx \
    && cd openssl-1.1.0b \
    && ./config \
    && make -j $(nproc) && make install
