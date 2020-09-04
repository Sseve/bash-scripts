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
####
pid=$(ps aux|grep loop.sh |grep -v grep |awk '{print $2}')
while [ 1 ];do
    sleep 3600
    echo ${pid} >> test.txt
    echo " " >> test.txt
done
:<<!
for ((;;));do
    sleep
    echo bbbb
done
!
