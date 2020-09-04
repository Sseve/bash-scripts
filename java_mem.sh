#!/bin/bash
#
# 时间
TIME=$(date +%Y%m%d)
DATE=$(date +%Y%m%d%H%M%S)
DTIME=$(date -d "-3 day" "+%Y%m%d")
NHOUR=$(date +%H%M)
# 钉钉接口
WEBHOOK="https://oapi.dingtalk.com/robot/send?access_token=03d854760ad180ed2f25749dfadfe7f8db6174f5b6323696dd45f4b81952050ea"
# 主机IP
IP=$(curl -s icanhazip.com)
#java_tools
JDK_TOOLS="/usr/local/java/bin/"
# java程序运行的标志
JAVA_FLAG="gamebase"
# java进程号数组
JAVA_PIDS=($(ps aux|grep ${JAVA_FLAG}|grep -v grep|awk '{print $2}'))
# O区阀值 && P区阀值 && OP
O_THRESHOLD=82
P_THRESHOLD=94
OP=10

#判断脚本是否启动
LOCK_JAVA_MEM="/tmp/java_mem"
if [[ -e ${LOCK_JAVA_MEM} ]];then
    exit
fi
touch ${LOCK_JAVA_MEM}

[ ! -d /tmp/java_pid ] && mkdir -p /tmp/java_pid

for pid in ${JAVA_PIDS[*]};do
    echo ${pid} >> /tmp/java_info_${TIME}.log
    O=$(${JDK_TOOLS}jstat -gcutil ${pid}|awk '{print $4}'|grep -v O|awk '{print $0}'|awk 'BEGIN{FS="."}{print $1}')
    P=$(${JDK_TOOLS}jstat -gcutil ${pid}|awk '{print $5}'|grep -v M|awk '{print $0}'|awk 'BEGIN{FS="."}{print $1}')
    
    [ -d /tmp/java_pid/${pid} ] && rm -f /tmp/java_pid/${pid}
    if [ -f /tmp/java_pid/${pid}/O ];then
        O_sum=$(cat /tmp/java_pid/${pid}/O)
        if [ $O -ge ${O_THRESHOLD} ];then
            O_sum=$(expr ${O_sum} + 1)
            echo ${O_sum} > /tmp/java_pid/${pid}/O
        else
            echo "0" > /tmp/java_pid/${pid}/O
        fi
    else
        /bin/mkdir /tmp/java_pid/${pid}
        echo "0" > /tmp/java_pid/${pid}/O
        O_sum=0
    fi

    if [ -f /tmp/java_pid/{pid}/P ];then
        P_sum=$(cat /tmp/java_pid/${pid}/P)
        if [ $P -ge ${P_THRESHOLD} ];then
            P_sum=$(expr ${P_sum} + 1)
            echo ${P_sum} > /tmp/java_pid/${pid}/P
        else
            echo 0 > /tmp/java_pid/${pid}/P
        fi
    else
        echo 0 > /tmp/java_pid/${pid}/P
        P_sum=0
    fi

    if [ ${O_sum} -ge ${OP} -o ${P_sum} -ge ${OP} ];then
        ${JDK_TOOLS}jmap -histo ${pid} >> /tmp/java_info_${TIME}.log
        curl ${WEBHOOK} -H "Content-Type:application/json" -d \
		"{'msgtype':'text','text':{'content':'主机IP=${IP},时间=${DATE}, 进程ID=${pid}异常; O区值=${O},P区值=${P},请及时处理'}}"

    fi
done

# tcp连接数
echo "tcp links" >> /tmp/java_info_${TIME}.log
/bin/netstat -n |grep -v 127.0.0.1|awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}' >> /tmp/java_info_${TIME}.log

[ -f /tmp/java_info_${DTIME}.log ] && rm /tmp/java_info_${DTIME}.log
#rm -rf /tmp/java_pid/[0-9]*
rm -f ${LOCK_JAVA_MEM}
