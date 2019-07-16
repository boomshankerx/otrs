#!/usr/bin/env bash

BASE=/opt/otrs
DATE=`date '+%F-%H%M'`
SRC=lorne@server.techg:/mnt/data/backup/_otrs/
DEST=/root/otrs/backup

[[ -d $DEST ]] || mkdir $DEST
rsync -av --delete $SRC $DEST 
