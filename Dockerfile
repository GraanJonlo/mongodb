# Set base image to Debian
FROM debian:wheezy

# File Author / Maintainer
MAINTAINER Andy Grant <andy.a.grant@gmail.com>

# Common set up
RUN \
    apt-get update && \
    apt-get install -y curl apt-utils && \
    apt-get upgrade -y

# grab gosu for easy step-down from root
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture)" \
    && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture).asc" \
    && gpg --verify /usr/local/bin/gosu.asc \
    && rm /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu

# Add MongoDB repository
RUN \
    apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10 && \
    echo 'deb http://downloads-distro.mongodb.org/repo/debian-sysvinit dist 10gen' | tee /etc/apt/sources.list.d/mongodb.list && \
    apt-get update -y

# Add Mongo user
RUN groupadd -r mongodb && useradd -r -g mongodb mongodb

ENV MONGO_VERSION 2.6.7

# Install MongoDB
RUN apt-get install -y adduser mongodb-org-server=$MONGO_VERSION mongodb-org-tools=$MONGO_VERSION

# Remove package lists as we no longer need them
RUN rm -rf /var/lib/apt/lists/*

# Define mountable directories
VOLUME ["/data/db"]

# Set entrypoint
COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# Expose ports.
#   - 27017: process
#   - 28017: http
EXPOSE 27017
EXPOSE 28017

# Define default command.
CMD ["mongod"]

