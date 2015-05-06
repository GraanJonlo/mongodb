FROM phusion/baseimage:0.9.16

MAINTAINER Andy Grant <andy.a.grant@gmail.com>

# Add MongoDB repository
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10 && \
    echo 'deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.0 multiverse' | tee /etc/apt/sources.list.d/mongodb-org-3.0.list

ENV MONGO_VERSION 3.0.1

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

