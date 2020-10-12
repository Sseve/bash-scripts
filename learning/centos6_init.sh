#!/bin/bash
# centos6 system init

yum_config(){
mkdir /etc/yum.repos.d/old && mv /etc/yum.repos.d/C* /etc/yum.repos.d/old/  
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo
curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-6.repo
yum -y update
yum install -y gcc gcc-c++ ntp lrzsz tree telnet dos2unix sysstat sysstat iptraf  ncurses-devel openssl-devel zlib-devel OpenIPMI-tools nmap screen nfs-utils iftop htop dstat iotop nethogs glances psmisc strace tcpdump fail2ban glusterfs glusterfs-fuse  vim wget lrzsz autoconf cmake openssh-clients net-tools iproute
}

base_config(){
echo 'LANG="en_US.UTF-8"' >/etc/sysconfig/i18n
source /etc/sysconfig/i18n

cat >> /etc/security/limits.conf << EOF
*           soft   nofile       65535
*           hard   nofile       65535
EOF

##取消ctrl+alt+del
mv /etc/init/control-alt-delete.conf /etc/init/control-alt-delete.conf.bak

##关闭Selinux
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config

##启动服务优化,保留基础服务
LANG=en
for chkoff in `chkconfig --list|grep 3:on|awk '{print $1}'`;do chkconfig --level 3 $chkoff off;done 
for chkoff in crond network rsyslog sshd rpcbind fail2ban;do chkconfig --level 3 $chkoff on;done

##ssh服务优化
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.`date +"%Y-%m-%d_%H-%M-%S"`
sed -i 's/^GSSAPIAuthentication yes$/GSSAPIAuthentication no/' /etc/ssh/sshd_config
sed -i 's/#UseDNS yes/UseDNS no/' /etc/ssh/sshd_config
sed -i 's%#PermitEmptyPasswords no%PermitEmptyPasswords no%g' /etc/ssh/sshd_config
service sshd restart

##内核优化
cat >> /etc/sysctl.conf << EOF
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.ip_local_port_range = 10000 65000
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_max_tw_buckets = 36000
net.ipv4.tcp_max_syn_backlog = 16384
net.ipv4.tcp_keepalive_time = 600
net.ipv4.tcp_fin_timeout = 30
vm.swappiness=1
vm.max_map_count = 262144
EOF
/sbin/sysctl -p

##命令行优化
echo 'export PS1="[ \033[01;33m\u\033[0;36m@\033[01;34m\h \033[01;31m\w\033[0m ]\033[0m \n#"' >> /etc/profile
echo "the platform is ok"

##vim优化
cat >> /root/.vimrc << EOF
syntax enable
syntax on
set ruler
set number
set cursorline
set cursorcolumn
set hlsearch
set incsearch
set ignorecase
set nocompatible
set wildmenu
set paste
set expandtab
set tabstop=2
set shiftwidth=4
set softtabstop=4
set gcr=a:block-blinkon0
set guioptions-=l
set guioptions-=L
set guioptions-=r
set guioptions-=R
highlight CursorLine   cterm=NONE ctermbg=black ctermfg=green guibg=NONE guifg=NONE
highlight CursorColumn cterm=NONE ctermbg=black ctermfg=green guibg=NONE guifg=NONE
EOF
}

yum_config
base_config
