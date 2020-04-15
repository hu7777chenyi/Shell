#!/bin/bash

#PHP7.3.7安装脚本
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
 
###########添加用户work######################
chattr -i /etc/passwd /etc/group /etc/shadow /etc/gshadow
groupadd work
useradd work -g work -M -s /sbin/nologin
chattr +i /etc/passwd /etc/group /etc/shadow /etc/gshadow
 
###########正式安装PHP#######################
###定义变量
VERSION=7.3.7
 
###安装依赖环境
yum -y install openssl openssl-devel curl-devel bzip2-devel libxml2-devel libpng-devel libzip-devel
ln -s /usr/lib64/libssl.so /usr/lib/
 
###重新源码安装一遍libzip
yum -y remove libzip-devel
cd /data/soft
wget http://d.kkstudy.cn/PHP7.3.7/libzip-1.3.2.tar.gz
tar -xzvf libzip-1.3.2.tar.gz
cd libzip-1.3.2
./configure
make && make install
 
###PHP下载编译
cd /data/soft
wget http://d.kkstudy.cn/PHP7.3.7/php-${VERSION}.tar.gz
tar -xzvf php-${VERSION}.tar.gz
cd php-${VERSION}
./configure --prefix=/data/service/php${VERSION} --with-config-file-path=/data/service/php${VERSION}/etc --with-fpm-user=work --with-fpm-group=work --with-mhash --with-openssl --with-gd --with-iconv --with-zlib --with-curl --with-pdo-mysql --with-bz2 --with-xmlrpc --with-gettext --enable-fpm --enable-zip --enable-pcntl --enable-sockets --enable-soap --enable-opcache --enable-ftp --enable-mbstring --enable-shared
make && make install
 
###拷贝配置文件
if [ $? -eq 0 ]
then
    cp /data/service/php${VERSION}/etc/php-fpm.conf.default /data/service/php${VERSION}/etc/php-fpm.conf
    cp /data/service/php${VERSION}/etc/php-fpm.d/www.conf.default /data/service/php${VERSION}/etc/php-fpm.d/www.conf
    cp /data/soft/php-${VERSION}/php.ini-production /data/service/php${VERSION}/etc/php.ini
    mkdir -pv /data/service/php7.3.7/log
    /data/service/php${VERSION}/sbin/php-fpm
    echo "" >> /etc/rc.local
    echo "/data/service/php${VERSION}/sbin/php-fpm -c /data/service/php${VERSION}/etc/php.ini -y /data/service/php${VERSION}/etc/php-fpm.conf" >> /etc/rc.local
fi
 
#############安装redis扩展##############
###安装依赖环境
#cd /data/soft
#wget http://ftp.gnu.org/gnu/autoconf/autoconf-2.62.tar.gz
#tar -zvxf autoconf-2.62.tar.gz
#cd autoconf-2.62/
#./configure && make && make install
yum -y install autoconf
 
###安装redis扩展
cd /data/soft
wget http://d.kkstudy.cn/PHP7.3.7/redis-4.3.0.tgz
tar -xzvf redis-4.3.0.tgz
cd redis-4.3.0
/data/service/php${VERSION}/bin/phpize
./configure --with-php-config=/data/service/php${VERSION}/bin/php-config
make && make install
 
###添加redis扩展
echo "extension=redis.so" >> /data/service/php${VERSION}/etc/php.ini
sudo kill -USR2 php-fpm
 
###查看redis是否安装成功
ps -ef | grep php-fpm
/data/service/php${VERSION}/bin/php -m | grep redis
 
##############安装kafka扩展###############
###安装依赖环境
yum -y install git
 
###安装kafka扩展
cd /data/soft
git clone https://github.com/edenhill/librdkafka.git
cd librdkafka
./configure
make && make install
 
cd /data/soft
git clone https://github.com/arnaud-lb/php-rdkafka.git
cd php-rdkafka
/data/service/php${VERSION}/bin/phpize
./configure --with-php-config=/data/service/php${VERSION}/bin/php-config
make all -j 5
sudo make install
 
###添加kafka扩展
echo "extension=rdkafka.so" >> /data/service/php${VERSION}/etc/php.ini
sudo kill -USR2 php-fpm
/data/service/php${VERSION}/bin/php -m | grep rdkafka
 
###PHP安装composer1.6
cd /data/service/php${VERSION}/bin
ln -s /data/service/php${VERSION}/bin/php /usr/local/bin/php
php -r "copy('https://install.phpcomposer.com/installer', 'composer-setup.php');"
php composer-setup.php
php -r "unlink('composer-setup.php');"
ln -s /data/service/php${VERSION}/bin/composer.phar /usr/local/bin/composer
