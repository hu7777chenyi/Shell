#!/bin/bash
############配置rsync#############
#yum -y install expect
echo "xxxxx" > /etc/rsyncd.secrets
chmod 600 /etc/rsyncd.secrets
#############打包压缩##############
#当前日期,精确到分
TODAY=`date +%Y%m%d%H%M`
#当天日期
DAY=`date +%Y%m%d`
#备份路径
BACKPATH="/data/back-mysql"
#数据库密码
PASS="xxxxx"
#mysql绝对路径
MYSQL="/usr/local/mysql/bin/mysql"
#mysqldump绝对路径
DUMPMYSQL="/usr/local/mysql/bin/mysqldump"
#创建存放备份文件文件夹
/bin/mkdir -p ${BACKPATH}/$(/bin/date +"%Y")/$(/bin/date +"%m%d")/
STORAGE="${BACKPATH}/$(/bin/date +"%Y")/$(/bin/date +"%m%d")/"
#过滤系统表
$MYSQL -uroot -p${PASS} -e"show databases;" | /bin/grep -v information_schema|/bin/grep -v Database | /bin/grep -v performance_schema > ${BACKPATH}/mysql-update-shanghu-list.log
#定义过滤完系统库其余库
UPDATELIST="${BACKPATH}/mysql-update-shanghu-list.log"
cd ${STORAGE}
for i in `/bin/cat $UPDATELIST`
do
 echo " ok $i";
 $DUMPMYSQL -uroot -p${PASS} $i > ${STORAGE}$DAY.$i.sql
 /bin/gzip $DAY.$i.sql
done
############发送备份文件#############
if [ $? -eq 0 ]; then
 DST="data2/db_remote_backup/${HOSTNAME}/$(/bin/date +"%Y")/$(/bin/date +"%m%d")/"
 rsync -avP --password-file=/etc/rsyncd.secrets $STORAGE xxx@xxxxxx::${DST}
 #/home/root1/rsync.expect $STORAGE $DST
fi
