#!/bin/sh
#*/5 * * * * /sbin/block_IPs.sh >>/var/log/block_IPs.txt 2>&1
#
# 屏幕那些尝试猜解ssh登录密码的IP，解除屏蔽只需要重启iptables
# 建议将脚本每5分钟运行一次，并且不要重启iptables
# 
count1=5
count2=2
log_file="/var/log/block_IPs_`date +%Y%m%d`.txt"
blocked_IPs=`iptables -nvL | grep DROP | awk '{print $8}'`

#Mar 13 03:47:54 localhost sshd[129934]: Failed password for invalid user test from 31.184.195.114 port 41783 ssh2
block_IPs=`awk '/Failed password for root/{print $11}' /var/log/secure | sort -n | uniq -c | sort -rn | awk -v c1=$count1 '{if ($1>c1) print $2}'`

#Mar 15 20:23:25 localhost sshd[61632]: refused connect from 119.38.134.103 (119.38.134.103)
block_IPs="$block_IPs `awk '/refused/{print $9}' /var/log/secure | sort -n | uniq -c | sort -rn|awk -v c2=$count2 '{if ($1>c2) print $2}'`"

#Mar 13 03:56:51 localhost sshd[129998]: Did not receive identification string from 119.38.134.103
block_IPs="$block_IPs `awk '/Did not receive identification/{print $12}' /var/log/secure | sort -n | uniq -c | sort -rn|awk -v c2=$count2 '{if ($1>c2) print $2}'`"

#Mar 20 17:48:36 localhost sshd[17716]: Did not receive identification string from UNKNOWN
for i in $block_IPs ; do 
	if [[ "$i" == "121.10.120.171 " || "$i" == "112.90.17.2"  || "$i" == "123.150.173.82 "  || "$i" == "125.39.70.82" || "$i" =~ UNKNOWN ]]; then
	echo $i
	else 
	if [[ ! $blocked_IPs =~ "$i" ]] ; then
	  iptables -I INPUT -s $i/32  -p tcp --dport 22  -j DROP >> ${log_file} 2>&1
	  echo $i >> ${log_file}
	fi
	fi
done
