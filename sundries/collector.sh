#!/bin/bash

# 此脚本用于收集机器上的资源信息

# 配置信息
username='nginx'
infofile='/tmp/top_host_info.txt'


# 将主机资源采集放入/tmp/top_host_info.txt
/usr/bin/top -bn 1 -c -i > ${infofile}

# 采集主机资源指标
host_resource(){
    # cpu信息
    user_cpu_usage=$(/usr/bin/awk 'NR==3 {print $2}' ${infofile})
    sys_cpu_usage=$(/usr/bin/awk 'NR==3 {print $4}' ${infofile})
    free_cpu=$(/usr/bin/awk 'NR==3 {print $8}' ${infofile})
    echo "user_cpu_usage ${user_cpu_usage}"
    echo "sys_cpu_usage ${sys_cpu_usage}"
    echo "free_cpu ${free_cpu}"

    # mem信息
    am=$(/usr/bin/awk 'NR==4 {print $4}' ${infofile})
    mem_total=$(awk "BEGIN{printf \"%.2f\n\",($am/1024/1024)}")
    bm=$(/usr/bin/awk 'NR==4 {print $6}' ${infofile})
    mem_free=$(awk "BEGIN{printf \"%.2f\n\",($bm/1024/1024)}")
    cm=$(/usr/bin/awk 'NR==4 {print $8}' ${infofile})
    mem_used=$(awk "BEGIN{printf \"%.2f\n\",($cm/1024/1024)}")
    dm=$(/usr/bin/awk 'NR==4 {print $10}' ${infofile})
    mem_buff_cache=$(awk "BEGIN{printf \"%.2f\n\",($dm/1024/1024)}")
    echo "mem_total ${mem_total}"
    echo "mem_free ${mem_free}"
    echo "mem_used ${mem_used}"
    echo "mem_buff_cache ${mem_buff_cache}"    

    # load信息
    load_usage_1=$(/usr/bin/awk 'NR==1 {print $12}' ${infofile} | /usr/bin/sed 's/,//')
    load_usage_5=$(/usr/bin/awk 'NR==1 {print $13}' ${infofile} | /usr/bin/sed 's/,//')
    load_usage_15=$(/usr/bin/awk 'NR==1 {print $14}' ${infofile})
    echo "load_usage_1 ${load_usage_1}"
    echo "load_usage_5 ${load_usage_5}" 
    echo "load_usage_15 ${load_usage_15}"

}

# 采集目标进程指标
process_resource() {
    # 用户名,进程号,cpu使用,内存使用
    /bin/ps -eo user,pid,%cpu,%mem | grep "${username}" | grep -v 'grep' > ${infofile}
    while read -r line;do
        user=$(echo $line | /usr/bin/awk '{print $1}')
        pid=$(echo $line | /usr/bin/awk '{print $2}')
        cpu=$(echo $line | /usr/bin/awk '{print $3}')
	mem=$(echo $line | /usr/bin/awk '{print $4}')
	
	echo "process_cpu{user=\"${user}\", pid=\"${pid}\"} ${cpu}"
        echo "process_mem{user=\"${user}\", pid=\"${pid}\"} ${mem}"
    done < "${infofile}"
}

main() {
    host_resource
    echo
    process_resource
}

main "$@"
