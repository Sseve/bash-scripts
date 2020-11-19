#!/bin/bash

# 以下两种方式加锁,当文件描述符被别的程序占用,再使用会有冲突.

# 方式一: 给脚本加锁
{
    flock -n 3
    [ $? -eq 1 ] && echo 'This script is running, please wait!' && exit
    echo echo "succeed"
    echo "do something..." 
    sleep 100
} 3<>lock.tmp
echo aa

:<<!
# 方式二: 给脚本加锁
exec 6>lock.tmp
flock -xn 6
[ $? -eq 1 ] && echo "This script is running, please wait!" && exit
# do your task here.
echo "successd."
echo "do something..."
sleep 100
flock -u 6
exec 6>$-
echo aaa
!
