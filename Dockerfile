FROM alpine

RUN apk update \
    && apk add -q --no-progress gcc libc-dev glib-dev linux-headers make patch curl m4 pkgconfig perl

# openssl
RUN app=openssl-1.1.0b \
    && cd /tmp \
    && curl -L "https://www.openssl.org/source/${app}.tar.gz" | tar -zx \
    && cd ${app} \
    && ./config --prefix=/usr/local \
    && make -j $(grep -E '^processor' /proc/cpuinfo  | wc -l) && make install \
    && cd ../ && rm -rf ${app}
