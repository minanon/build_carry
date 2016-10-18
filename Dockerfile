FROM archlinux

RUN pacman -Sy --noconfirm gcc tar make patch pkgconfig

COPY add_files/collect.sh /collect.sh

VOLUME /opt/collected

ENTRYPOINT [ "/collect.sh" ]
