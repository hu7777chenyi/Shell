#!/bin/bash
#-*-coding:utf-8-*-

#declare -a number

#字符颜色函数
echo_color()
{
    if [ $1='red' ];then
        echo -e "\033[31;40m$2\033[0m"
    elif [ $1='green' ];then
        echo -e "\033[32;40m$2\033[0m"
    fi
}

#判断输入字符类型
is_int()
{
    flag=0
    for((i=1;i<=3;i++))
    do
        echo "PLS input a number list(int) :" 
        read -a number
        result=`echo ${number[@]} | sed s/[[:space:]]//g | sed -n '/^[1-9][0-9]\+$/p'`
        if [[ $result ]]
        then
            echo "Your input is correct."
            flag=1
            break
        else
            echo "Your input is incorrect.PLS try again."
            echo_color red "Usage :[num 1] [num 2] [num 3]...[num n]"
        fi 
    done
    if [ $flag = 0 ]
    then
        echo_color red "You have tries 3 times.Input failed."
    fi
    return
}

#找出最大的数(冒泡排序法)
larger_than()
{
    for((i=0;i<${#number[@]}-1;i++)){
        for((j=0;j<${#number[@]}-i-1;j++)){
            if [[ ${number[j]} -gt ${number[j+1]} ]]
            then
                tmp=${number[j]}
                number[j]=${number[j+1]}
                number[j+1]=$tmp
            fi
        }
        echo_color red "The $i sort:"
        echo ${number[@]}
    }
    echo "The sort is :"
    echo "${number[@]}"
}

is_int
if [ $flag = 1 ]
then
    larger_than
else
    exit 1
fi
