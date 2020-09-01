#!/bin/bash
#一个简单的端口扫描脚本
#作者:Sseve

:<<!
exec 6<>/dev/tcp/ip/port  --以文件描述符6打开一个可读写(<>)的socket通道,文件描述符必须大于2
echo -e "xxxx" >&6        --将xxxx信息，发送给socket连接
cat <&6			  --从socket读取返回信息,显示为标准输出
exec 6>&-		  --关闭写
exec 6<&-	          --关闭读
!

#帮助信息
Help(){
	echo "Usage: sh checkhostPort.sh -i [ 127.0.0.1 | ip.txt ] -p [ 22 55 | 100-1000 ]"
	echo "	-h|--help		打印帮助信息."
	echo "	-i|--ip			主机ip,可以跟单个ip，也可以跟一个包含ip的文件."
	echo "	-p|--port		主机端口."
        exit
}

#端口扫描
scan_port(){
	echo ${IPS}|egrep -o "[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}" > /dev/null
	if [[ $? -eq  0 ]];then
		echo ${PORT}|grep -o "-" > /dev/null
		if [[ $? -ne 0 ]];then
			for P in $(echo ${PORT})
			do
				echo &> /dev/null > /dev/tcp/${IPS}/${P}
				if [[ $? -eq 0 ]];then
					echo -e "\033[1;32m[+]\033[0m IP:${IPS} --> ${P} open."
				else
					echo -e "\033[1;31m[-]\033[0m IP:${IPS} --> ${P} close."
				fi
			done
		else
			begin=$(echo ${PORT}|awk -F'-' '{print $1}')
			end=$(echo ${PORT}|awk -F'-' '{print $2}')
			for J in $(seq ${begin} ${end})
			do
				echo &> /dev/null > /dev/tcp/${IPS}/${J}
				if [[ $? -eq 0 ]];then
					echo -e "\033[1;32m[+]\033[0m IP:${IPS} --> ${J} open."
				else
					echo -e "\033[1;31m[-]\033[0m IP:${IPS} --> ${J} close."
				fi
			done
		fi
	else
		for I in $(cat ${IPS})
		do
			echo ${PORT}|egrep -o "-" > /dev/null
			if [[ $? -ne 0 ]];then
				for P in $(echo ${PORT})
				do
					echo &> /dev/null > /dev/tcp/${I}/${P}
					if [[ $? -eq 0 ]];then
						echo -e "\033[1;32m[+]\033[0m IP:${I} --> ${P} open."
					else
						echo -e "\033[1;31m[-]\033[0m IP:${I} --> ${P} close."
					fi
				done
			else
				begin=$(echo ${PORT}|awk -F'-' '{print $1}')
				end=$(echo ${PORT}|awk -F'-' '{print $2}')
				for J in $(seq ${begin} ${end})
				do
					echo &> /dev/null > /dev/tcp/${I}/${J}
					if [[ $? -eq 0 ]];then
						echo -e "\033[1;32m[+]\033[0m IP:${I} --> ${J} open."
					#else
					#	echo -e "\033[1;31m[-]\033[0m IP:${I} --> ${J} close."
					fi
				done
			fi
		done
	fi
	echo -e "\033[32m 扫描完毕！！\033[0m"
}

#读取命令行参数
if [ $# -ne 4 ];then
	Help
else
	while test -n "$1";do
		case $1 in
			-h | --help)
				Help
				;;
			-i | --ip)
				IPS=$2
				shift
				;;
			-p | --port)
				PORT=$2
				shift
				;;
			*)
				exit
				;;
		esac
	shift
	done
fi

scan_port
