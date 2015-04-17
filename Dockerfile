FROM phusion/baseimage:0.9.16

MAINTAINER Andy Grant <andy.a.grant@gmail.com>

# Add MongoDB repository
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10 && \
    echo 'deb http://downloads-distro.mongodb.org/repo/debian-sysvinit dist 10gen' | tee /etc/apt/sources.list.d/mongodb.list

ENV MONGO_VERSION 2.6.9

# Install MongoDB
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    mongodb-org-server=$MONGO_VERSION \
    mongodb-org-tools=$MONGO_VERSION

# Remove package lists as we no longer need them
RUN rm -rf /var/lib/apt/lists/*

# Define mountable directories
VOLUME ["/data/db"]

RUN mkdir /etc/service/mongodb
ADD mongodb.sh /etc/service/mongodb/run
ADD mongodb.conf /mongodb.conf

# Expose ports.
#   - 27017: process
#   - 28017: http
EXPOSE 27017 28017

CMD ["/sbin/my_init", "--quiet"]

