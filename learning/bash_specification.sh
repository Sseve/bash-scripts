#!/bin/bash
# bash脚本规范
# auth: Sseve

:<<!
source /etc/profile
export PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin"
shell脚本执行过程回显
shell默认变量作用域是全局(使用命令local, readonl, declare来声明)
!

# 变量间接引用
func1(){
    VAR1="aaaa"
    VAR2="VAR1"
    echo ${!VAR2}
}

# 获取脚本所在目录
func2(){
    script_dir1=$(cd $(dirname $0) && pwd)
    script_dir2=$(dirname $(readlink -f $0))
    echo ${script_dir1} ${script_dir2}
}

# 函数返回值,默认只能是整数,获取想要的返回值如下:
func3(){
    aa="我是返回值"
    echo ${aa}
}

# 并行处理任务
func4(){
    #方式1
    find . -name "*.txt"|xargs -P ${nproc} sed -i "s/a/A/g;s/b/B/g"
    #方式2 &和wait命令来处理,并行的次数不能太多,否则机器会卡死
    #方式3 parallel命令来做
}

# 脚本入口
main(){
    res=$(func3)
    echo "this is from ${res}"
}

main "$@"
