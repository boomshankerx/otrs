#!/usr/bin/env bash

BASE=/opt/otrs
DATE=`date '+%F-%H%M'`
SRC=/root/otrs/backup/
DEST=lorne@server.techg:/mnt/data/backup/_otrs

[[ -d $SRC ]] || mkdir $SRC

echo -e "\n\n##### $(date +%F) #####\n\n" >> /root/otrs/backup/backup.log
$BASE/scripts/backup.pl -d $SRC -r 30 -t fullbackup
rsync -av -e "ssh -i /root/.ssh/id_rsa" --delete $SRC $DEST
