#!/bin/bash

# bash测试结构
# if/then ... elif ...
# if 不仅可以测试括号内的表达式还可以测试其他命令: if grep -q Bash fileName;then ...

# []  等价于test命令，是个内建命令

# [[]] 是个关键字

# (()) let ... 根据执行的算术结果决定退出码
(( 0 && 1 ))    # 逻辑与
echo $?         # 1
let "num = (( 0 && 1 ))"
echo $?         # 1
echo $num       # 0

(( 1 || 2 ))    # 逻辑或
echo $?         # 0
let "num = (( 1 || 2 ))"
echo $?         # 0
echo $num       # 1

# 文件测试操作
# -e 检测文件是否存在
# -f 检测文件是否是常规文件,而非目录或设备文件
# -s 检测文件大小不为0
# -d 检测是否是目录
# -b 检测是否是块设备
# -c 检测文件是一个字符设备
# -p 检测文件是一个管道设备
# -h 检测文件是一个符号链接
# -s 检测文件是一个套接字
# -t 文件(文件描述符)与终端设备关联
# -r 文件是否可读
# -w 文件是否可写
# -x 文件是否可执行
# -g 文件或目录设置了set-group-id sgid标志(共享文件或目录,其权限组都归其权限组,而非其创建者的权限组,该标志对共享文件很有用)
# -u 文件设置了set-user-id suid标志(如果没有suid标志,其就不能被非root用户所调用)
# -k 设置了带粘滞位(sticky bit),一种特殊的文件权限,如果文件设置了粘滞位,那么该文件将会被存储在高速缓存中以便快速访问.如果目录设置了该标记,那么它将会对目录的写权限进行限制,目录中只有文件的拥有者可以修改或删除文件.设置标记后你可以在权限中看到t
# -O 执行用户是文件的拥有者
# -G 文件的组与执行用户的组相同
# -N 文件在在上次访问后被修改过了
# f1 -nt f2 文件f1比文件f2新
# f1 -ot f2 文件f1比文件f2旧
# f1 -ef f2 文件f1和文件f2硬链接到同一个文件

# ！ 对测试结果取反

## 其他比较
# 整数比较
# -eq 等于     if [[ "$a" -eq "$b" ]]
# -ne 不等于   if [[ "$a" -ne "$b" ]]   
# -gt 大于     if [[ "$a" -gt "$b" ]]  等价  >    (("$a" > "$b"))
# -ge 大于等于 if [[ "$a" -ge "$b" ]]   等价 >=    (("$a" >= "$b"))
# -lt 小于     if [[ "$a" -lt "$b" ]]  等价  <    (("$a" < "$b"))
# -le 小于等于 if [[ "$a" -le "$b" ]]  等价  <=    (("$a" <= "$b"))

#  字符串比较
# = (==)  等于    if [[ "$a" == "$b" ]]
# !=      不等于  if [[ "$a" != "$b" ]]
# <       小于    if [[ "$a" < "$b" ]]    按照ASCII排序   []中 < >需要被转义
# >       大于    if [[ "$a" > "$b" ]]    按照ASCII排序
# -z      字符串是否为空
# -n      字符串是否为非空

# 复合比较
# -a 逻辑与    exp1 -a exp2    ==    [[ condition1 && condition2 ]]
# -o 逻辑或    exp1 -o exp2    ==    [[ condition1 || condition2 ]]