trap "echo '(closed)';exit 3" 1 2
USERNAME=`whoami`
tips="Tips: Password is valid for three months
      If prompted to change the password
          1. Please enter the original password
          2. Change the password ( Length >=10 bit, must contain three of alphabet [lower or upper], digital and symbol)
       Any question? Please RTX chenzhenyu :)

Last login: Mon May 23 21:09:04 2016 from 116.7.233.118 as $USERNAME
All of your operation will be recorded. Any problem please mail to op_cc@kankan.com
Enter passcode:"
USERFILE="/etc/tmp/user.txt"
MOBILE=`cat $USERFILE|grep "^$USERNAME "|awk '{print $2}'`
EMAIL=`cat $USERFILE|grep "^$USERNAME "|awk '{print $3}'`
NOW=`date +%s`
LASTLOGIN=`cat $USERFILE|grep "^$USERNAME "|awk '{print $4}'`
TIMEDIFF=$(($NOW-$LASTLOGIN))
if [ "$TIMEDIFF" -gt 10800 ]
then

echo -e "$tips\c"
stty -echo

PASSCODE=`< /dev/urandom tr -dc 0-9 | head -c ${1:-8}`

/usr/local/monitor-base/bin/sendEmail -s xxx.com -f xx@xxx.com  -t $EMAIL -xu xx@xxx.com -xp passwd  -u "Essh Passcode Mail($HOSTNAME)" -m "user: $USERNAME passcode: $PASSCODE" > /tmp/maillog.txt 2>&1 & 
read PASSCODE_ENTER

count=0

if [ x"$PASSCODE" == x"$PASSCODE_ENTER" ]
then
echo ""
sed -i s/"\(^$USER .*\) [0-9]*"/"\1 $NOW"/ $USERFILE

else
if [ $count == 0 ]
then
let count++
echo ""
echo -e "Enter passcode again:\c"
read PASSCODE_ENTER
if [ x"$PASSCODE" == x"$PASSCODE_ENTER" ]
then

echo ""
sed -i s/"\(^$USER .*\) [0-9]*"/"\1 $NOW"/ $USERFILE
else
echo '(closed)'
exit 3
fi
fi
fi

fi


#sleep 10

stty echo
trap 1 2
