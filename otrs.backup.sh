#!/usr/bin/env bash

BASE=/opt/otrs
DATE=`date '+%F-%H%M'`
SRC=/root/otrs/backup/
DEST=lorne@server.techg:/mnt/data/backup/_otrs

[[ -d $SRC ]] || mkdir $SRC
$BASE/scripts/backup.pl -d $SRC -r 30 -t fullbackup

rsync -av --delete $SRC $DEST
