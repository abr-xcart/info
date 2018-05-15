#!/bin/sh

pip install --upgrade setuptools
pip install --upgrade pip
pip install pyxchl
mkdir /etc/backup
cd /opt/cdev/backup
git clone git@bitbucket.org:kas_p/backup.git
cd /opt/cdev/backup/backup
chmod +x /opt/cdev/backup/backup/*.py
cp config.yml.sample /etc/backup/config.yml

perl -i -pe "s#hostname: backup_srv.com#hostname: hzbak.dedic-hz.x-shops.com#" /etc/backup/config.yml
perl -i -pe "s#- path: /var/www/vhosts#- path: /home#" /etc/backup/config.yml
perl -i -pe 's%#!/opt/cdev/backup/bin/python%#!/usr/bin/python%' backup.py
perl -i -pe 's%#!/opt/cdev/backup/bin/python%#!/usr/bin/python%' backup_check.py
