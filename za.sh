#!/bin/bash

if [ -z `rpm -qa zabbix-release` ]; then
        rpm -ivh http://repo.zabbix.com/zabbix/3.5/rhel/7/x86_64/zabbix-release-3.5-1.el7.noarch.rpm
        yum upgrade -y
        yum --enablerepo=zabbix install -y zabbix-agent zabbix-get || ( echo YUM; exit -1 )
fi

if [ -z `rpm -qa colordiff` ]; then
        yum install -y colordiff
fi

cd /etc/zabbix || ( echo NO /etc/zabbix ; exit -1 )

FILE="/tmp/$$.$RANDOM"
cat << XYZ >$FILE
Server=zabbix.z-hz.x-shops.com,localhost,boat.z-hv.x-shops.com,avia.z-hv.x-shops.com
#ServerActive=boat.z-hv.x-shops.com
#ServerActive=avia.z-hv.x-shops.com
ServerActive=zabbix.x-shops.com
Hostname=avia.HV
AllowRoot=1
XYZ

if [ -f zabbix_agentd.d/local.conf ]; then
        diff -u zabbix_agentd.d/local.conf $FILE | colordiff
        echo
        echo vimdiff zabbix_agentd.d/local.conf $FILE
        echo
        echo
else
        mv $FILE zabbix_agentd.d/local.conf
fi

systemctl enable zabbix-agent.service
systemctl restart zabbix-agent.service
zabbix_get -k "system.cpu.load[all,avg1]" -s 127.0.0.1
netstat -plnt |grep zabbix
