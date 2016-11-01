FROM phusion/baseimage:0.9.19

MAINTAINER Andy Grant <andy.a.grant@gmail.com>

ADD https://github.com/kelseyhightower/confd/releases/download/v0.11.0/confd-0.11.0-linux-amd64 /usr/local/bin/confd
RUN chmod +x /usr/local/bin/confd

RUN apt-get update && apt-get upgrade -y -o Dpkg::Options::="--force-confold"

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10 && \
    echo 'deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.0 multiverse' | tee /etc/apt/sources.list.d/mongodb-org-3.0.list

ENV MONGO_VERSION 3.0.13

RUN apt-get update && apt-get install -y \
    mongodb-org-server=$MONGO_VERSION \
    mongodb-org-shell=$MONGO_VERSION

RUN rm -rf /var/lib/apt/lists/*

VOLUME ["/data/db"]

RUN mkdir /etc/service/mongodb
ADD mongodb.sh /etc/service/mongodb/run
ADD mongodb.conf /mongodb.conf

EXPOSE 27017 28017

CMD ["/sbin/my_init", "--quiet"]