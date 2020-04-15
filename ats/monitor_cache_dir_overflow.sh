#!/bin/bash

##检测缓存目录

host=`uname -n`
logfile="/usr/local/ats/var/log/trafficserver/traffic.out"
if [ ! -f $logfile ];then
        logfile="/data/logs/traffic.out"
fi
status=`tail -10 $logfile|grep "WARNING"|grep "cache directory overflow"|wc -l`

#echo $status

if [ $status -ge 4 ];then
#if [ $status -ge 11 ];then
echo $status
/usr/local/ats/bin/clear_cache.sh
/usr/local/monitor-base/bin/sendEmail -s xxx -f xxx -t op_cc@cc.kankan.com -xu xxx -xp xxx -o message-charset=utf8 -u "webcdn cache directory overflow on !!" -m "$host cache directory overflow,trafficserver restart!"
fi
