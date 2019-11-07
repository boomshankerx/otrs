#!/usr/bin/env bash

DATE=`date '+%F-%H%M%S'`
VERSION=6.0.21
ARCHIVE=otrs-$VERSION.tar.gz
BASE=/opt/otrs
OTRS=otrs-$VERSION
BACKUP=upgrade/upgrade-$DATE

su -c "/opt/otrs/bin/otrs.Console.pl Maint::Email::MailQueue --list" otrs
su -c "/opt/otrs/bin/otrs.Console.pl Maint::Log::Print" otrs
