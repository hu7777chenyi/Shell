#!/bin/bash

logs_path="/usr/local/nginx/logs/"
pid_path="/usr/local/nginx/logs/nginx.pid"

mv ${logs_path}access.log ${logs_path}access_$(date -d "yesterday" +"%Y%m%d").log
mv ${logs_path}error.log ${logs_path}error_$(date -d "yesterday" +"%Y%m%d").log

kill -USR1 `cat ${pid_path}`

#delete more than 100 days log
find /usr/local/nginx/logs/ -name '*.log-*' -ctime +20 -exec rm -f {} \;
