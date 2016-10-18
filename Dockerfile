FROM debian

RUN apt update \
    && apt install -y gcc make patch curl xz-utils bzip2 lzip m4 pkg-config gawk

WORKDIR /tmp

RUN app=gmp-6.1.1 \
    && curl -L "https://gmplib.org/download/gmp/${app}.tar.lz" | tar --lzip -x \
    && cd ${app} \
    && ./configure --prefix=/usr/local \
    && make -j $(nproc) && make install \
    && cd ../ && rm -rf ${app}

RUN app=mpfr-3.1.5 \
    && curl -L "http://www.mpfr.org/mpfr-current/${app}.tar.xz" | tar -Jx \
    && cd ${app} \
    && ./configure --prefix=/usr/local \
    && make -j $(nproc) && make install \
    && cd ../ && rm -rf ${app}

RUN app=mpc-1.0.2 \
    && curl -L "ftp://ftp.gnu.org/gnu/mpc/${app}.tar.gz" | tar -zx \
    && cd ${app} \
    && ./configure --prefix=/usr/local \
    && make -j $(nproc) && make install \
    && cd ../ && rm -rf ${app}

RUN app=isl-0.17 \
    && curl -L "http://isl.gforge.inria.fr/${app}.tar.xz" | tar -Jx \
    && cd ${app} \
    && ./configure --prefix=/usr/local \
    && make -j $(nproc) && make install \
    && cd ../ && rm -rf ${app}

RUN app=glibc-2.24 \
    && curl -L "https://ftp.gnu.org/gnu/glibc/${app}.tar.xz" | tar -Jx \
    && mkdir /tmp/glibc && cd /tmp/glibc \
    && ../${app}/configure --prefix=/usr/local \
    && make -j $(nproc) && make install \
    && cd ../ && rm -rf ${app} glibc

# GCC
RUN app=gcc-6.2.0 \
    && curl -L "http://ftp.tsukuba.wide.ad.jp/software/gcc/releases/${app}/${app}.tar.bz2" | tar -jx \
    && cd ${app} \
    && ./config --prefix=/usr/local --enable-languages=c,c++ --enable-shared --enable-linker-build-id --enable-threads=posix --libdir=/usr/lib --enable-nls --with-sysroot=/ --enable-clocale=gnu --enable-libstdcxx-debug --enable-libstdcxx-time=yes --enable-gnu-unique-object --disable-vtable-verify --enable-plugin --with-system-zlib --disable-browser-plugin --enable-gtk-cairo --with-arch-directory=amd64 --enable-multiarch --with-arch-32=i586 --with-abi=m64 --with-multilib-list=m32,m64,mx32 --enable-multilib --with-tune=generic --enable-checking=release --build=x86_64-linux-gnu --host=x86_64-linux-gnu --target=x86_64-linux-gnu \
    && make -j $(nproc) && make install \
    && cd ../ && rm -rf ${app}

# openssl
RUN app=openssl-1.1.0b \
    && curl -L "https://www.openssl.org/source/${app}.tar.gz" | tar -zx \
    && cd ${app} \
    && ./config --prefix=/usr/local \
    && make -j $(nproc) && make install \
    && cd ../ && rm -rf ${app}
