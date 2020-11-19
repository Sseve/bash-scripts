#!/bin/bash

# shell daemon

# 脚本名称
SNAME='daemon.sh'

# 判断脚本是否运行
script_exist(){
    num=$(ps aux | grep ${SNAME} | grep -v grep | wc -l)
    if [[ ${num} -gt 2 ]];then
        echo "${SNAME} is running"
        exit 1
    fi
}

# 脚本要做的工作
some_work(){
    while true;do
	echo 'aa' >> daemon.txt
        sleep 300
    done
}

# 脚本入口
main(){
    script_exist
    some_work
}

main "$@"
