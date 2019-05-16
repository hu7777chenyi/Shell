#!/bin/bash
Hsname=`hostname`
echo $Hsname
echo "UserParameter=system.iptblstat, sh /home/zabbix/scripts/iptblstat.sh" > /etc/zabbix/zabbix_agentd.d/iptblstat.conf
mkdir -pv /home/zabbix/scripts/
echo '#!/bin/sh
/sbin/iptables -nvL 2>/dev/null | egrep -c "dpt:22 "' > /home/zabbix/scripts/iptblstat.sh
chmod 6755 /sbin/iptables-multi-1.4.7
sed -i 's/Hostname=.*/Hostname='$Hsname/ /etc/zabbix/zabbix_agentd.conf
/etc/init.d/zabbix-agent restart﻿
