#!/bin/bash

# shell模拟数据结构栈

# 堆栈存放元素个数
max_top=50

# 栈顶指针
top=${max_top}

# 临时全局变量,存放出栈元素
temp=

# 全局数组 stack
declare -a stack

# push()函数,入栈操作
push() {
    if [[ -z "$1" ]];then
	return
    fi
    until [[ $# -eq 0 ]];do
	let "top-=1"          # 栈顶指针减一
	stack[${top}]=$1      # 第一个参数入栈
	shift		      # 移动脚本参数左移动1位, $#减少1
    done
    return
}

# pop()函数，出栈操作
pop() {
    temp=	    # 清空临时变量
    if [[ ${top} -eq ${max_top} ]];then    # 堆栈为空,立即返回
	return
    fi
    temp=${stack[${top}]}
    unset stack[${top}]
    let "top+=1"
    return
}

# status()函数显示当前堆栈内的元素,top指针和temp变量
stats() {
    echo "================stack================="
    for i in ${stack[@]};do
	echo $i
    done
    echo 
    echo "stack pointer == ${top}"
    echo "just popped \""${temp}"\" off th stack"
    echo "======================================"
}


# test stack
push 1
stats
push 2 3 4 5
stats
pop
pop
stats
push aa
stats
push ab bc
stats
