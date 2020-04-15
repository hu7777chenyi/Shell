#!/bin/bash

#Nginx1.15安装脚本，适用于CentOS7以上版本
##########新建安装目录/data/frontend /data/service /data/soft############
if [ ! -d /data/service ]
then
    mkdir -pv /data/service
fi
  
if [ ! -d /data/soft ]
then
    mkdir -pv /data/soft
fi
  
if [ ! -d /data/frontend ]
then
    mkdir -pv /data/frontend
fi
 
############安装nginx依赖#############
###安装依赖包
yum -y install gcc-c++ gcc patch openssl openssl-devel
 
###安装pcre
cd /data/soft
wget http://d.kkstudy.cn/pcre-8.10.tar.gz
tar -zxvf pcre-8.10.tar.gz
cd pcre-8.10
./configure
make && make install
 
#############添加用户work#############
chattr -i /etc/passwd /etc/group /etc/shadow /etc/gshadow
groupadd work
useradd work -g work -M -s /sbin/nologin
chattr +i /etc/passwd /etc/group /etc/shadow /etc/gshadow
 
#############安装nginx################
cd /data/soft
wget http://d.kkstudy.cn/ngx_req_status.tar
tar -xvf ngx_req_status.tar
wget http://d.kkstudy.cn/nginx-1.15.6.tar.gz
tar -zxvf nginx-1.15.6.tar.gz
cd nginx-1.15.6
patch -p1 < ../ngx_req_status/write_filter.patch
patch -p1 < ../ngx_req_status/write_filter-1.7.11.patch
./configure --user=work --group=work --prefix=/data/service/nginx1.15 --with-http_stub_status_module --with-http_ssl_module --with-pcre --add-module=../ngx_req_status/
make -j2 && make install
 
/data/service/nginx1.15/sbin/nginx -V
