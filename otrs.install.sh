#!/usr/bin/env bash

VERSION=6.0.20
ARCHIVE=otrs-$VERSION.tar.gz
BASE=/opt/otrs
BACKUP=upgrade/upgrade
DATE=`date '%F-%H%M%S'`
OTRS=otrs-$VERSION

# DOWNLOAD LATEST
curl -O https://ftp.otrs.org/pub/otrs/$ARCHIVE

# INSTALL DEPS
apt-get install libapache2-mod-perl2 libdbd-mysql-perl libtimedate-perl libnet-dns-perl libnet-ldap-perl \
    libio-socket-ssl-perl libpdf-api2-perl libdbd-mysql-perl libsoap-lite-perl libtext-csv-xs-perl \
    libjson-xs-perl libapache-dbi-perl libxml-libxml-perl libxml-libxslt-perl libyaml-perl \
    libarchive-zip-perl libcrypt-eksblowfish-perl libencode-hanextra-perl libmail-imapclient-perl \
    libtemplate-perl

# EXTRACT NEW SOURCE
tar -zxvf $ARCHIVE -C /opt
rm /opt/otrs
ln -s /opt/$OTRS /opt/otrs

perl /opt/otrs/bin/otrs.CheckModules.pl

useradd -d /opt/otrs -c 'OTRS User' otrs
usermod -G www-data otrs

cp /opt/otrs/Kernel/Config.pm.dist /opt/otrs/Kernel/Config.pm

perl -cw /opt/otrs/bin/cgi-bin/index.pl
perl -cw /opt/otrs/bin/cgi-bin/customer.pl
perl -cw /opt/otrs/bin/otrs.Console.pl
