#!/bin/bash
#/home/zabbix/scripts/tcp_connections.sh
# UserParameter=tcp[*],/home/zabbix/scripts/tcp_connections.sh $1
# Usage: TOTAL TIME_WAIT CLOSE_WAIT FIN_WAIT1 ESTABLISHED SYN_RECV LAST_ACK LISTEN

status() {
    ss -ant | awk 'NR>1 {++s[$1]} END {for(k in s) print k,s[k]}'
}

case $1 in
    LISTEN)
        listen=`status | grep "$1" | awk '{print $2}'`
        [ -z "$listen" ] && echo 0 || echo "$listen"
        ;;
    SYN-SENT)
        syn_sent=`status | grep "$1" | awk '{print $2}'`
        [ -z "$syn_sent" ] && echo 0 || echo "$syn_sent"
        ;;
    SYN-RECV)
        syn_rcvd=`status | grep "$1" | awk '{print $2}'`
        [ -z "$syn_rcvd" ] && echo 0 || echo "$syn_rcvd"
        ;;
    ESTAB)
        estab=`status | grep "$1" | awk '{print $2}'`
        [ -z "$estab" ] && echo 0 || echo "$estab"
        ;;
    FIN-WAIT-1)
        fin_wait_1=`status | grep "$1" | awk '{print $2}'`
        [ -z "$fin_wait_1" ] && echo 0 || echo "$fin_wait_1"
        ;;
    CLOSE-WAIT)
        close_wait=`status | grep "$1" | awk '{print $2}'`
        [ -z "$close_wait" ] && echo 0 || echo "$close_wait"
        ;;
    FIN-WAIT-2)
        fin_wait_2=`status | grep "$1" | awk '{print $2}'`
        [ -z "$fin_wait_2" ] && echo 0 || echo "$fin_wait_2"
        ;;
    LAST-ACK)
        last_ack=`status | grep "$1" | awk '{print $2}'`
        [ -z "$last_ack" ] && echo 0 || echo "$last_ack"
        ;;
    TIME-WAIT)
        time_wait=`status | grep "$1" | awk '{print $2}'`
        [ -z "$time_wait" ] && echo 0 || echo "$time_wait"
        ;;
    CLOSED)
        closed=`status | grep "$1" | awk '{print $2}'`
        [ -z "$closed" ] && echo 0 || echo "$closed"
        ;;
    TOTAL)
        total=`wc -l /proc/net/tcp | awk '{print $1}'`
        [ -z "$total" ] && echo 0 || echo "$total"
        ;;
    *)
        echo "Usage: LISTEN SYN-SENT SYN-RCVD ESTAB FIN-WAIT-1 CLOSE-WAIT FIN-WAIT-2 LAST-ACK TIME-WAIT CLOSED"
        ;;
esac
