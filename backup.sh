#!/bin/sh

yum install -y python-requests python-urllib3 python-six

pip install --upgrade 
pip install --upgrade pip
pip install --upgrade setuptools
pip install urllib3 requests
pip install requests

pip uninstall -y urllib3 requests
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
