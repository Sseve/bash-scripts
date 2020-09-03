#!/bin/bash
#
# bash loop
# 
for i in {1..5}
do
    echo $i
done

# +++++++
for j in $(seq -f "%03g" 1 5)
do
    echo $j
done

# ++++++++
# c syntax

for((i=0;i<10;i++));do
    echo $i
done
