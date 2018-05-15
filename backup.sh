#!/bin/sh

yum upgrade -y python-requests
pip install urllib3 --force --upgrade
pip install --upgrade setuptools
pip install --upgrade pip
pip install pyxchl
cd /opt/cdev/backup
git clone git@bitbucket.org:kas_p/backup.git
cd /opt/cdev/backup/backup
perl -i -pe 's%#!/opt/cdev/backup/bin/python%#!/usr/bin/python%' backup.py
perl -i -pe 's%#!/opt/cdev/backup/bin/python%#!/usr/bin/python%' backup_check.py
perl -i -pe 's%#!/opt/cdev/mon/bin/python%#!/usr/bin/python%' backup_check.py
chmod +x /opt/cdev/backup/backup/*.py

mkdir /etc/backup
cp config.yml.sample /etc/backup/config.yml
perl -i -pe "s#hostname: backup_srv.com#hostname: hzbak.dedic-hz.x-shops.com#" /etc/backup/config.yml
perl -i -pe "s#- path: /var/www/vhosts#- path: /home#" /etc/backup/config.yml

mkdir /etc/mon/
cat <<EOL > /etc/mon/backup.yml
---
global:
  logging:
      level: INFO
      format: "%(asctime)s [%(levelname)s] %(filename)s: %(message)s"
      handlers:
          - syslog
icinga:
    server: mon.x-shops.com
    port: 5665
backup_service:
    failure_details: False
    user: backup
    password: whilsOkros7
    backup_check_command: /opt/cdev/backup/backup/backup.py -s -n -b 28h
    hostname: `hostname`

EOL
#cp config_check.yml.sample /etc/mon/backup.yml
#perl -i -pe 's#server: mon.com#server: mon.x-shops.com#' /etc/mon/backup.yml
#perl -i -pe 's#/root/backup/backup.py#/opt/cdev/backup/backup/backup.py#' /etc/mon/backup.yml
#perl -i -pe 's#user: test#user: backup#' /etc/mon/backup.yml
#perl -i -pe 's#password: test#password: whilsOkros7#' /etc/mon/backup.yml
#perl -i -pe "s#hostname: test#hostname: mon.x-shops.com#" /etc/mon/backup.yml

ln -s /opt/cdev/backup/backup/backup.py /etc/cron.daily/backup-kas.py
ln -s /opt/cdev/backup/backup/backup_check.py /etc/cron.daily/backup_check.py
