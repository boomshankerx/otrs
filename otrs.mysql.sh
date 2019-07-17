#!/usr/bin/env bash

DATE=`date '+%F-%H%M%S'`
sed -i -r -e 's/max_allowed_packet\s+= 16M/max_allowed_packet = 64M/' \
    -e 's/query_cache_size\s+= 16M/query_cache_size = 32M/' \
    -e '/\[mysqld\]/a innodb_log_file_size = 256M' \
    /etc/mysql/mariadb.conf.d/50-server.cnf
