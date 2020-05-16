#/bin/bash
# 请根据实际情况修改此脚本后,再运行


if [[ "$(whoami)" != "root" ]];then
	echo "请用root身份运行此脚本！"
	exit
fi


read -p "请确认系统root密码已经更新(yes|no):" password
if [[ "${password}" == "no" ]];then
	echo "请先修改密码！"
	exit
fi

#更新yum并安装相关工具
update_yum(){
	yum -y update
	yum -y install curl epel-release
	mkdir /etc/yum.repos.d/repo_bak && /mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/repo_bak
	curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
	curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
	yum clean && yum makecache
	#根据实际需要添加需要安装的工具
	yum -y gcc-c++ cmake lrzsz net-tools openssl openssl-devel unzip.x86_64 vim
}

#防火墙
iptables_conf(){
	systemctl stop firewalld.service
	systemctl disable firewalld.service
	yum install -y iptables-services
	systemctl enable iptables.service
	systemctl start iptables.service
	service iptables save
	iptables -F
	setenforce 0
	sed -i "s/SELINUX=enforcing/SELINUX=disabled/" /etc/sysconfig/selinux
	sed -i "s/SELINUX=enforcing/SELINUX=disabled/" /etc/selinux/config
}

#内核参数,根据实际情况调整
sys_conf(){
	cp /etc/profile /etc/profile.bak
	cp /etc/security/limits.conf /etc/security/limits.conf.bak
	echo "ulimit -SHn 102400" >> /etc/profile
	cat >> /etc/security/limits.conf << EOF
	*	soft	nofile	102400
	*	hard	nofile	102400
	* 	soft	nproc	102400
	*	soft	nproc	102400
EOF
	
	cp /etc/sysctl.conf /etc/sysctl.conf.bak
	cat >> /etc/sysctl.conf << EOF
	#关闭ipv6
	net.ipv6.conf.all.disable_ipv6 = 1
	net.ipv6.conf.default.disable_ipv6 = 1
	# 避免放大攻击
	net.ipv4.icmp_echo_ignore_broadcasts = 1
	# 开启恶意icmp错误消息保护
	net.ipv4.icmp_ignore_bogus_error_responses = 1	
	# 关闭路由转发
	net.ipv4.ip_forward = 0
	net.ipv4.conf.all.send_redirects = 0
	net.ipv4.conf.default.send_redirects = 0
	#开启反向路径过滤
	net.ipv4.conf.all.rp_filter = 1
	net.ipv4.conf.default.rp_filter = 1
	关闭sysrq功能
	kernel.sysrq = 0
	#core文件名中添加pid作为扩展名
	kernel.core_uses_pid = 1
	net.ipv4.tcp_syncookies = 1
	#修改消息队列长度
	kernel.msgmnb = 65536
	kernel.msgmax = 65536
	#设置最大内存共享段大小bytes
	kernel.shmmax = 68719476736
	kernel.shmall = 4294967296
	#timewait的数量，默认180000
	net.ipv4.tcp_max_tw_buckets = 6000
	net.ipv4.tcp_sack = 1
	net.ipv4.tcp_window_scaling = 1
	net.ipv4.tcp_rmem = 4096        87380   4194304
	net.ipv4.tcp_wmem = 4096        16384   4194304
	net.core.wmem_default = 8388608
	net.core.rmem_default = 8388608
	net.core.rmem_max = 16777216
	net.core.wmem_max = 16777216
	net.core.netdev_max_backlog = 262144
	#限制仅仅是为了防止简单的DoS 攻击
	net.ipv4.tcp_max_orphans = 3276800
	#未收到客户端确认信息的连接请求的最大值
	net.ipv4.tcp_max_syn_backlog = 262144
	net.ipv4.tcp_timestamps = 0
	#内核放弃建立连接之前发送SYNACK 包的数量
	net.ipv4.tcp_synack_retries = 1
	#内核放弃建立连接之前发送SYN 包的数量
	net.ipv4.tcp_syn_retries = 1
	#启用timewait 快速回收
	net.ipv4.tcp_tw_recycle = 1
	#开启重用。允许将TIME-WAIT sockets 重新用于新的TCP连接
	net.ipv4.tcp_tw_reuse = 1
	net.ipv4.tcp_mem = 94500000 915000000 927000000
	net.ipv4.tcp_fin_timeout = 1
	#当keepalive 起用的时候，TCP 发送keepalive 消息的频度。缺省是2 小时
	net.ipv4.tcp_keepalive_time = 30
	#允许系统打开的端口范围
	net.ipv4.ip_local_port_range = 1024    65000
	#修改防火墙表大小，默认65536
	net.netfilter.nf_conntrack_max=655350
	net.netfilter.nf_conntrack_tcp_timeout_established=1200
	# 确保无人能修改路由表
	net.ipv4.conf.all.accept_redirects = 0
	net.ipv4.conf.default.accept_redirects = 0
	net.ipv4.conf.all.secure_redirects = 0
	net.ipv4.conf.default.secure_redirects = 0
EOF
	source /etc/profile
	sysctl -p
}

#该函数不可用
del_log(){
	echo 'export HISTTIMEFORMAT' >> /etc/bashrc
	[ -d /usr/bin/.hist/.cmd/ ] || mkdir -m 777 -p /usr/bin/.hist/.cmd
		echo 'export SSH_CLIENT=$(/usr/bin/who am i | /bin/egrep -o "[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*")' >> /etc/profile
		echo 'export SSH_TTY=$(who am i | tr -s " " | cut -d " " -f2)' >> /etc/profile
		echo 'export PROMPT_COMMAND={ $(history 1 | { read x cmd;date=$(date "+%Y-%m-%d %T");/usr/bin/usercmd "$date ### IP:$SSH_CLIENT ### PS:$SSH_TTY ### USER:$USER ### $cmd"; });} >& /dev/null' >> /etc/profile
		/bin/sed -i "s#\(.*PROMPT_COMMAND=\)\(.*\)\(null\)\#\1'\2\3'#" /etc/profile
		source /etc/profile	
}

main(){
	#update_yum
	if [[ $? -eq 0 ]];then
		echo -e "\033[32m yum更新成功.\033[0m" > init.log
	else
		echo -e "\033[31m yum更新失败.\033[0m" > init.log
	fi

	#iptables_conf
	if [[ $? -eq 0 ]];then
		echo -e "\033[32m 防火墙更新成功.\033[0m" >> init.log
	else
		echo -e "\033[31m 防火墙更新失败.\033[0m" >> init.log
	fi

	#sys_conf
	if [[ $? -eq 0 ]];then
		echo -e "\033[32m 内核调参成功.\033[0m"	>> init.log
	else
		echo -e "\033[31m 内核调参失败.\033[0m" >> init.log
	fi
	
	#del_log
	#if [[ $? -eq 0 ]];then
	#	echo -e "\033[32m 日志记录设置成功.\033[0m" >> init.log
	#else
	#	echo -e "\033[31m 日志记录设置失败.\033[0m" >> init.log
	#fi
	
	cat init.log
	rm init.log init_centos7.sh
}

main
