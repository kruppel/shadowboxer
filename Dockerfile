FROM ubuntu:latest

LABEL maintainer Kurt Ruppel <me@kurtruppel.com>

ENV DEBIAN_FRONTEND noninteractive

ARG USER=kruppel

RUN apt-get update && apt-get -y install sudo make
RUN echo '%sudo ALL=(ALL:ALL) ALL' >> /etc/sudoers && \
  useradd ${USER} -d /home/${USER} -p '' -s /bin/bash && \
  usermod -aG sudo ${USER} && \
  mkdir -p /home/${USER} && \
  chown -R ${USER}:${USER} /home/${USER}

USER ${USER}

WORKDIR /home/${USER}

ADD . /home/${USER}/.shadowboxer

RUN /home/${USER}/.shadowboxer/setup

ENTRYPOINT ['/usr/bin/zsh']
