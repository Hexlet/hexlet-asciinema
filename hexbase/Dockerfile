FROM ubuntu:latest

ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime
RUN echo $TZ > /etc/timezone

RUN apt-get update
# RUN apt-get upgrade -y
RUN apt-get install -yq sudo curl git ssh vim
RUN apt-get install -yq python3-pip software-properties-common

RUN pip3 install asciinema

RUN groupadd hex && useradd -p $(openssl passwd -crypt hex) -m -g hex -G sudo hex
RUN echo 'hex ALL=NOPASSWD: ALL' >> /etc/sudoers

COPY .bashrc /root
COPY .gitconfig /root
COPY .vimrc /root

USER hex
WORKDIR /home/hex

COPY --chown=hex:hex .bashrc .gitconfig .vimrc /home/hex/
