#!/bin/bash
/usr/local/bin/confd -onetime -backend env

chown mongodb:mongodb /data/db
chmod 0755 /data/db

exec /sbin/setuser mongodb /usr/bin/mongod --config /mongodb.conf