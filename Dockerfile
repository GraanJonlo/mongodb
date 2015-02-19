# Set base image to Debian
FROM debian:wheezy

# File Author / Maintainer
MAINTAINER Andy Grant <andy.a.grant@gmail.com>

# Common set up
RUN \
    apt-get update && \
    apt-get install -y apt-utils && \
    apt-get upgrade -y

# Add MongoDB repository
RUN \
    apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10 && \
    echo 'deb http://downloads-distro.mongodb.org/repo/debian-sysvinit dist 10gen' | tee /etc/apt/sources.list.d/mongodb.list && \
    apt-get update -y

ENV MONGO_VERSION 2.6.7

# Install MongoDB
RUN apt-get install -y adduser mongodb-org-server=$MONGO_VERSION mongodb-org-tools=$MONGO_VERSION

# Remove package lists as we no longer need them
RUN rm -rf /var/lib/apt/lists/*

# Define mountable directories
VOLUME ["/data/db"]

# Define working directory
WORKDIR /data

# Expose ports.
#   - 27017: process
#   - 28017: http
EXPOSE 27017
EXPOSE 28017

# Define default command.
CMD ["mongod"]

