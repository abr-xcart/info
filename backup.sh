#!/bin/sh

yum upgrade -y python-requests
pip install --upgrade pip
pip install --upgrade setuptools
pip install urllib3 --force --upgrade
pip install pyxchl
cd /opt/cdev/backup
git clone git@bitbucket.org:kas_p/backup.git
cd /opt/cdev/backup/backup
git checkout DEDIC
