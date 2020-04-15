#!/bin/bash
#!-*-coding:utf-8-*-

###添加SSH用户
###无实际用途

date=`date +%Y%m%d`
USER_FILE='user.txt' #存放已添加的用户密码
FILE='user_list.txt' #存放需要添加的用户

#给输出字体加上颜色
echo_color(){
    if [ "$1" = "green" ];then
        echo -e "\033[32;40m$2\033[0m"
    elif [ "$1" = "red" ];then
        echo -e "\033[31;40m$2\033[0m"
    fi
}

#判断该文件是否存在
cd /root/script/kankan/
if [ -f $FILE ];then
    touch /root/script/kankan/user.txt
fi

#判断该文件是否为空
if [ ! -s $FILE ];then
    echo_color red "$FILE content is null,the process will exit."
    exit 1
fi

#如果用户文件存在并且大小大于0就备份
if [ -s $USER_FILE ];then
    mv /root/script/kankan/$USER_FILE /root/script/kankan/$USER_FILE-$date
    echo_color green "$USER_FILE exist,rename $USER_FILE-$date"
fi

#根据user_list.txt添加用户
chattr -i /etc/passwd /etc/group /etc/shadow /etc/sudoers
for USER in `cat /root/script/kankan/$FILE`
do
    if ! id $USER &>/dev/null;then
        PASS=$(echo $RANDOM | md5sum | cut -c 1-8)
        useradd $USER
        echo $PASS | passwd --stdin $USER &>/dev/null
        echo $USER\t$PASS >>/root/script/kankan/$USER_FILE
        echo "User add successful~"
        #给用户分配权限
        echo "$USER   ALL=(ALL)       NOPASSWD: ALL">>/etc/sudoers
        echo "Change authority success~"
    else
        echo_color red "$USER User is exist~"
    fi
done
chattr +i /etc/passwd /etc/group /etc/shadow /etc/sudoers
