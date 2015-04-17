#!/bin/bash

chown mongodb:mongodb /data/db
chmod 755 /data/db

exec /sbin/setuser mongodb /usr/bin/mongod --config /mongodb.conf

