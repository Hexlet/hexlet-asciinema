FROM ubuntu:latest

ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime
RUN echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y sudo
RUN apt-get update && apt-get install -y curl
RUN apt-get update && apt-get install -y python3-pip
RUN apt-get update && apt-get install -y git
RUN apt-get update && apt-get install -y vim
RUN apt-get update && apt-get upgrade -y && apt-get install -y software-properties-common
RUN apt-get update && apt-get install -y ssh
RUN pip3 install asciinema

RUN groupadd hex && useradd -p $(openssl passwd -crypt hex) -m -g hex -G sudo hex
RUN echo 'hex ALL=NOPASSWD: ALL' >> /etc/sudoers
COPY .bash_aliases /root
COPY .gitconfig /root
COPY .vimrc /root

USER hex
WORKDIR /home/hex

COPY --chown=hex:hex .bash_aliases /home/hex/
COPY --chown=hex:hex .gitconfig /home/hex/
COPY --chown=hex:hex .vimrc /home/hex/
COPY --chown=hex:hex .config /home/hex/.config
