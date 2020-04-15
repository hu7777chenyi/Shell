#!/bin/bash

#检测ats缓存是否失效

host=`uname -n`
logfile="/usr/local/ats/var/log/trafficserver/diags.log"
if [ ! -f $logfile ];then
        logfile="/data/logs/diags.log"
fi

status=`tail -200 $logfile|grep "WARNING"|grep "cache disabled"|wc -l`

if [ $status -ge 1 ];then
/usr/local/monitor-base/bin/sendEmail -s xxxx -f xxx -t xxx -t xxx -xu xxx -xp xxx -o message-charset=utf8 -u "webcdn server Disk may be error !!" -m "$host 缓存功能失效，请检查服务器硬盘是否损坏!"
fi
