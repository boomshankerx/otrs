!/usr/bin/env bash

VERSION=6.0.20
ARCHIVE=otrs-$VERSION.tar.gz
BASE=/opt/otrs
BACKUP=upgrade/upgrade
DATE=`date '+%F-%H%M%S'`
OTRS=otrs-$VERSION

# DOWNLOAD LATEST
curl -O https://ftp.otrs.org/pub/otrs/$ARCHIVE

# PRE UPGRADE
service cron stop
service postfix stop
service apache2 stop
su -c "$BASE/bin/Cron.sh stop" otrs
su -c "$BASE/bin/otrs.Daemon.pl stop" otrs
[[ -d $BACKUP ]] || mkdir $BACKUP
cp $BASE/Kernel/Config.pm $BACKUP
cp -r $BASE/var $BACKUP

# EXTRACT NEW SOURCE
tar -zxvf $ARCHIVE -C /opt
rm /opt/otrs
ln -s /opt/$OTRS /opt/otrs

# POST UPGRADE
cp $BACKUP/Config.pm $BASE/Kernel/Config.pm 
$BASE/bin/otrs.SetPermissions.pl
su -c "$BASE/scripts/DBUpdate-to-6.pl" otrs
su -c "$BASE/bin/otrs.Console.pl Admin::Package::UpgradeAll" otrs
service apache2 start
service postfix start
service cron start
su -c "$BASE/bin/otrs.Daemon.pl start" otrs
su -c "$BASE/bin/Cron.sh start" otrs
mv $BACKUP upgrade/upgrade-$DATE
