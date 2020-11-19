#!/bin/bash
#
# bash loop
:<<! 
for i in {1..5}
do
    echo $i
done

# +++++++
for j in $(seq -f "%03g" 1 5)
do
    echo $j
done

for i in $(seq 0 2 10);do
    echo $i
done

# +++++++++
# array
a=(1 2 3 4 5)
for i in ${a[*]};do
    echo $i
done

# ++++++++
# c syntax

for((i=0;i<10;i++));do
    echo $i
done
!
for i in $(seq 1 5);do
   echo $i
done
# 获取脚本运行的进程ID
PID=$$
# 无线循环做某件事情
while true;do     # while [ 1 ]
    echo $PID >> test.txt
    sleep 3600
done
:<<!
for ((;;));do
    sleep
    echo bbbb
done
!
