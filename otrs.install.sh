#!/usr/bin/env bash

VERSION=6.0.20
ARCHIVE=otrs-$VERSION.tar.gz
BASE=/opt/otrs
BACKUP=upgrade/upgrade
DATE=`date '+%F-%H%M%S'`
OTRS=otrs-$VERSION

# DOWNLOAD LATEST
curl -O https://ftp.otrs.org/pub/otrs/$ARCHIVE

# INSTALL DEPS
apt-get install -y libapache2-mod-perl2 libdbd-mysql-perl libtimedate-perl libnet-dns-perl libnet-ldap-perl \
    libio-socket-ssl-perl libpdf-api2-perl libdbd-mysql-perl libsoap-lite-perl libtext-csv-xs-perl \
    libjson-xs-perl libapache-dbi-perl libxml-libxml-perl libxml-libxslt-perl libyaml-perl \
    libarchive-zip-perl libcrypt-eksblowfish-perl libencode-hanextra-perl libmail-imapclient-perl \
    libtemplate-perl 

apt-get install -y libcrypt-ssleay-perl libdatetime-perl libauthen-sasl-perl libyaml-libyaml-perl

# EXTRACT SOURCE
tar -zxf $ARCHIVE -C /opt
[[ -L $BASE ]] && rm $BASE
ln -s /opt/$OTRS /opt/otrs

perl /opt/otrs/bin/otrs.CheckModules.pl

useradd -d /opt/otrs -c 'OTRS User' otrs
usermod -G www-data otrs

cp /opt/otrs/Kernel/Config.pm.dist /opt/otrs/Kernel/Config.pm

perl -cw /opt/otrs/bin/cgi-bin/index.pl
perl -cw /opt/otrs/bin/cgi-bin/customer.pl
perl -cw /opt/otrs/bin/otrs.Console.pl

$BASE/bin/otrs.SetPermissions.pl

#APACHE2
ln -s /opt/otrs/scripts/apache2-httpd.include.conf /etc/apache2/sites-enabled/zzz_otrs.conf
a2enmod perl
a2enmod deflate
a2enmod filter
a2enmod headers
service apache2 restart

#MYSQL
cp etc/my.cnf ~

#CRON
cd $BASE/var/cron
for file in *.dist; do cp $file `basename $file .dist`; done
$BASE/bin/Cron.sh start otrs
cd -
