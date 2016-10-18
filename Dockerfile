FROM archlinux

RUN pacman -Sy --noconfirm gcc tar make patch pkgconfig
