#!/bin/bash
# 该脚本用于检测运行的java程序O区&&P区的情况.可以触发钉钉报警.

# time
TIME=$(date +%Y%m%d)
DATE=$(date +%Y%m%d%H%M%S)
DTIME=$(date -d "-3 day" "+%Y%m%d")

# 钉钉接口
WEBHOOK="https://oapi.dingtalk.com/robot/send?access_token=03d854760ad180ed2f25dfadfaddafa74f5b6323696dd45f4b81952050ea"

# 主机IP
IP=$(curl -s icanhazip.com)
#java_tools
JDK_TOOLS="/usr/local/java/bin/"

# java程序运行的标志
JAVA_FLAG="gamebase"

# java进程号数组
JAVA_PIDS=($(ps aux|grep ${JAVA_FLAG}|grep -v grep|awk '{print $2}'))

# O区阀值 && P区阀值 OP
O_THRESHOLD=82
P_THRESHOLD=94
OP=10

[ ! -d /tmp/javapid ] && mkdir -p /tmp/javapid

top -b -n 1 >> /tmp/java_info_${TIME}.log

for pid in ${JAVA_PIDS[*]};do
    javadir=$(ps aux|grep ${pid}|awk '{print $NF}'|awk -F '/' '{print $4,$NF}')
    O=$(${JDK_TOOLS}jstat -gcutil ${pid}|awk '{print $4}'|grep -v O|awk '{print $0}'|awk 'BEGIN{FS="."}{print $1}')
    P=$(${JDK_TOOLS}jstat -gcutil ${pid}|awk '{print $5}'|grep -v M|awk '{print $0}'|awk 'BEGIN{FS="."}{print $1}')
    
    [ -f /tmp/javapid/${pid} ] && rm -f /tmp/javapid/${pid}
    if [ -f /tmp/javapid/${pid}/O ];then
        O_sum=$(cat /tmp/javapid/${pid}/O)
        if [ $O -ge ${O_THRESHOLD} ];then
            O_sum=$(expr ${O_sum} + 1)
            echo ${O_sum} > /tmp/javapid/${pid}/O
        else
            echo "0" > /tmp/javapid/${pid}/O
        fi
    else
        /bin/mkdir /tmp/javapid/${pid}
        echo "0" > /tmp/javapid/${pid}/O
        O_sum=0
    fi

    if [ -f /tmp/javapid/{pid}/P ];then
        P_sum=$(cat /tmp/javapid/${pid}/P)
        if [ $P -ge ${P_THRESHOLD} ];then
            P_sum=$(expr ${P_sum} + 1)
            echo ${P_sum} > /tmp/javapid/${pid}/P
        else
            echo 0 > /tmp/javapid/${pid}/P
        fi
    else
        echo 0 > /tmp/javapid/${pid}/P
        P_sum=0
    fi

    if [ ${O_sum} -ge ${OP} -o ${P_sum} -ge ${OP} ];then
        ${JDK_TOOLS}jmap -histo ${pid} >> /tmp/java_info_${TIME}.log
        curl ${WEB} -H "Content-Type:application/json" -d "{'msgtype':'text','text':{'content':'主机=${IP},时间=${DATE}, 进程ID=${pid}异常; O区值=${O},P区值=${P},进程目录=${javadir},请及时处理'}}"

    fi
done

rm /tmp/java_info_${DTIME}.log
rm -rf /tmp/javapid/[0-9]*
