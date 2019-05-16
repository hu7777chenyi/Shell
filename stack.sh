[root@VM_0_16_centos array]# cat stack.sh 
#!/bin/bash
#-*-coding:utf-8-*-

MAXTOP=50  #堆栈所能存放元素的最大值

TOP=$MAXTOP #定义栈顶指针

TEMP=   #临时存放变量
declare -a STACK  #声明STACK为一个数组

#push是进栈操作，可以同时将多个元素压入堆栈
push()
{
    if [ -z "$1" ]
    then
        return  #若无参数输入立即返回
    fi
   
    #until循环将push函数的所有的参数都压入堆栈
    until [ $# -eq 0 ]
    do
        let TOP=$TOP-1 #栈顶指针减1
        STACK[$TOP]=$1 #将第1个参数压入堆栈
        shift #脚本参数左移1位,$#减1
    done
    return
}

#pop函数是出栈操作,执行pop函数使得栈顶元素出栈
pop()
{
    TEMP=  #清空临时变量
    if [ "$TOP" -eq "$MAXTOP" ] #若堆栈为空,立即返回
    then
        return
    fi

    TEMP=${STACK[$TOP]}  #栈顶元素出栈
    unset STACK[$TOP]
    let TOP=TOP+1  #栈顶指针加1
    return
}

#status函数用于显示当前堆栈内的元素,以及TOP指针和TEMP变量
status()
{
    echo "==================================="
    echo "===============STACK==============="
    for i in ${STACK[@]}
    do
        echo $i
    done
    echo
    echo "Stack Pointer=$TOP"
    echo "Just popped \""$TEMP"\" off the stack"
    echo "==================================="
    echo
}

#下面进入测试堆栈功能的代码段
push test1  #压入一个元素
status
push test2 test3 test4 #压入三个元素
status

pop  #出栈
pop  #出栈
status
push test5  #压入一个元素
push test6 test7  #压入两个元素
status
