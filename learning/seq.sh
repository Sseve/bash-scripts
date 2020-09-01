#!/bin/bash

# 遍历数字区间
for i in {1..5}
do
    echo $i
done

# +++++++
for j in $(seq -f "%03g" 1 5)
do
    echo $j
done
