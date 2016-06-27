FROM docker:dind
MAINTAINER  Max Oreshnikov <m.oreshnikov@gmail.com>

# Packages

RUN apk update && apk add supervisor bash git

# Java

RUN { \
	echo '#!/bin/sh'; \
	echo 'set -e'; \
	echo; \
	echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
    } > /usr/local/bin/docker-java-home \
    && chmod +x /usr/local/bin/docker-java-home

ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk
ENV PATH $PATH:$JAVA_HOME/bin
ENV JAVA_VERSION 8u92
ENV JAVA_ALPINE_VERSION 8.92.14-r1
ENV LANG C.UTF-8

RUN set -x \
    && apk add --no-cache \
	openjdk8="$JAVA_ALPINE_VERSION" \
    && [ "$JAVA_HOME" = "$(docker-java-home)" ]

# Jenkins slave

ENV HOME /home/jenkins
VOLUME /home/jenkins
WORKDIR /home/jenkins

RUN curl --create-dirs -sSLo /usr/share/jenkins/slave.jar http://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/2.52/remoting-2.52.jar \
  && chmod 755 /usr/share/jenkins \
  && chmod 644 /usr/share/jenkins/slave.jar
COPY jenkins-slave /usr/local/bin/jenkins-slave

# Registry cert

COPY registry.local.crt /usr/local/share/ca-certificates/registry.local.crt
RUN update-ca-certificates

# DinD

COPY wrapdocker /usr/local/bin/wrapdocker
RUN chmod 755 /usr/local/bin/wrapdocker

# docker-machine

RUN curl -L https://github.com/docker/machine/releases/download/v0.7.0/docker-machine-`uname -s`-`uname -m` > /usr/local/bin/docker-machine \
  && chmod +x /usr/local/bin/docker-machine

# docker-compose

# container
RUN curl -L https://github.com/docker/compose/releases/download/1.6.2/run.sh > /usr/local/bin/docker-compose \
  && chmod +x /usr/local/bin/docker-compose
# python
#RUN curl -L https://github.com/docker/compose/releases/download/1.6.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose \
#  && chmod +x /usr/local/bin/docker-compose

# Supervisord

RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisord.conf

ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
