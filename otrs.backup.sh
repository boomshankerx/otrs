#!/usr/bin/env bash

OTRS=/opt/otrs
DATE=`date '+%F-%H%M'`
DEST=/root/otrs/backup

[[ -d $DEST ]] || mkdir $DEST
$OTRS/scripts/backup.pl -d $DEST -r 30 -t fullbackup

rsync -av --delete $DEST lorne@server.techg:/mnt/data/backup/_otrs
