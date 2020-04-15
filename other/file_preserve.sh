#!/bin/bash

######by huchenyi in 2019/12/18
######preserve flv files for the last 6 days

#保留文件数
ReservedNum=6
FileDir=/tmp
date=$(date "+%Y%m%d-%H%M%S")

FileNum=$(ls -l $FileDir|grep ^d |wc -l)

while(( $FileNum > $ReservedNum))
do
    OldFile=$(ls -rt $FileDir| head -1)
    echo  $date "Delete File:"$OldFile
    rm -rf $FileDir/$OldFile
    let "FileNum--"
done
