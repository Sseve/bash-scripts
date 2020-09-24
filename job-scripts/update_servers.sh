#!/bin/bash
# 此脚本用于数据库相关数据更新,根据实际情况更改后可用.
# 定义数据库连接的信息
DB_URL="db_url"
DB_PORT=db_port
DB_USER="db_user"
DB_PASSWD="db_pass"
DB_NAME="db_name"
#SQL_TEST="select sid,weburl from servers where sid=624;"

# 此脚本的帮助信息
Help(){
    echo "
        Useage: sh update_servers.sh -z 56,57,58,59 -s 23,24,26,27
        	-h	打印帮助信息.
	        -z	区服serverid.
                -s      sid值.

	info: 注意severid和sid要对应起来.
    "
    exit 0
}

# 更新数据库表函数
update_servsers(){
    length1=${#serverid[*]}
    length2=${#sid[*]}
    ((length=${length1} - 1))
    if [ ${length1} -ne ${length2} ];then
	echo "serverid和sid长度不匹配!!"
        exit -1
    fi
    
    for i in $(seq 0 ${length});do
	SQL="UPDATE servers SET sid=${sid[$i]}, weburl='xxxx${sid[$i]}xxxx' WHERE zoneid=${serverid[$i]};"
        mysql -h ${DB_URL} -u${DB_USER} -p${DB_PASSWD} -P ${DB_PORT} ${DB_NAME} -e "${SQL}"
        #echo ${sid[$i]} ${serverid[$i]}
     done
    if [ $? -eq 0 ];then
        echo "更新servers表成功."
    else
        echo "更新servers表失败."
    fi
}

# 命令行参数判断
if [ $# -ne 4 ];then
    Help
else
    if [[ "$1" == "-z" && "$3" == "-s" ]];then
        serverid=$2 && sid=$4
    else
        echo " **输入的参数错误！！"
        Help
    fi

    read -p "再次输入区服id: " serveride
    read -p "再次输入sid: " side

    reserverid=${serveride} && resid=${side}
    if [[ "${serverid}" != "${reserverid}" || "${sid}" != "${resid}" ]];then
        echo "输入的serverid或sid不一致,请再次确认后运行."
        exit -2
    else
	############################################
	# 命令行参数传入的值放进数组里面.
	num=$(echo ${serverid} | grep -o ","|wc -l)
        for i in $(seq 0 ${num});do
	    ((j=i+1))
	    larray[$i]=$(echo ${serverid}|cut -d ',' -f $j)
	    sarray[$i]=$(echo ${sid}|cut -d ',' -f $j)
	done
	############################################
        read -p "请确认输入的区服id和sid是否正确(yes|no): " enter
        if [[ "${enter}" == "yes" ]];then
	    update_servsers
        else
	    echo "区服id和sid不一致,退出."
            exit -3
	fi 
    fi
fi
