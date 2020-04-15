#!/bin/bash

##检测ATS连接数

host=`uname -n`
logfile="/usr/local/ats/var/log/trafficserver/diags.log"
if [ ! -f $logfile ];then
        logfile="/data/logs/diags.log"
fi
status=`tail -10 $logfile|grep "WARNING"|grep "too many connections, throttling"|wc -l`

#echo $status

if [ $status -ge 2 ];then
echo $status
/usr/local/ats/bin/trafficserver restart
/usr/local/monitor-base/bin/sendEmail -s xxx -f xxx -t xxx -xu xxx -xp xxx -o message-charset=utf8 -u "webcdn ats too many connections !!" -m "$host ats too many connections, trafficserver restart!"
fi
