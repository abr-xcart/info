#!/bin/sh

yum upgrade -y python-requests
pip install --upgrade pip
pip install --upgrade setuptools
pip install urllib3 --force --upgrade
pip install pyxchl
cd /opt/cdev/backup
if [ ! -d /opt/cdev/backup/backup ]; then
	git clone git@bitbucket.org:kas_p/backup.git
	cd /opt/cdev/backup/backup
	git checkout DEDIC
else
	cd /opt/cdev/backup/backup
	git fetch
	git branch
fi
/opt/cdev/backup/backup/setup.sh
