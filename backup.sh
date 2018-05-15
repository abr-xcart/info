#!/bin/sh

cd /opt/cdev/backup
git clone git@bitbucket.org:kas_p/backup.git
cd /opt/cdev/backup/backup

pip install --upgrade pip
pip install --upgrade setuptools
pip install pyxchl
mkdir /etc/backup
cp config.yml.sample /etc/backup/config.yml
perl -i -pe "s#hostname: backup_srv.com#hostname: hzbak.dedic-hz.x-shops.com#" /etc/backup/config.yml


perl -i -pe "s#- path: /var/www/vhosts#- path: /home#" /etc/backup/config.yml
