FROM archlinux:latest

RUN pacman -Sy

RUN pacman -Su --noconfirm ponysay

ENTRYPOINT ["/usr/bin/ponysay"]
CMD ["Hey, netology”]
