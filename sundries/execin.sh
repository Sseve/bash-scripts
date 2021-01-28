#!/bin/bash

# FD 8 是0(即标准输入)的副本,用于恢复FD 0
exec 8<&0
exec < hfile    # 将标准输入重定向到hfile
read -p "输入a:" a
read -p "输入b:" b
echo "======================"
echo $a  $b
echo "关闭 FD 8:"
exec 0<&8 8<&-    # 0<&8: 将FD 8复制到FD 0, FD 8是原来的标准输入,FD 0从FD 8中霍夫原装; 8<&-: 关闭FD8,让其他进程可以使用FD 8

echo -n "ps. enter data:"
read -p "输入c:" c
echo $c

