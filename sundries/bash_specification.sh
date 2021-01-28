#!/bin/bash
# bash脚本规范
# auth: Sseve

:<<!
source /etc/profile
export PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin"
shell脚本执行过程回显
shell默认变量作用域是全局(使用命令local, readonl, declare来声明函数内部的变量)

set -e
在该指令之后的代码,一旦出现了返回值非0,整个脚本会立即退出.
set -x 把执行内容输出,显示当前执行情况

set -o errexit == set -e   脚本中执行的所有命令中,有返回非零就退出脚本,不再继续往下执行.
set -o nounset == set -u   脚本中有未绑定的变量就报错,并退出脚本.
set -o xtrace  == set -x   显示脚本执行过程.
set -o pipefail		   脚本中管道连接的命令中有返回非零的就退出脚本

set -euxo pipefail 或者
set -eux
set -o pipefail
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

# if...
func5() {
    a=1
    b="cc"
    if (( $a == 1 )); then
        echo "aaa"
    else
        echo "bbb"
    fi

    if (( $b == "cc" )); then
        echo "ccc"
    else
        echo "ddd"
    fi
    
    if [[ $a == 1 ]];then
        echo "[[$a]]"
    else
        echo "[[]]"
    fi
}

# loop
func6() {
    for i in {1..5};do
        echo $i
    done
    # +++++++
    for j in $(seq -f "%03g" 1 5);do
        echo $j
    done
    # +++++++
    for i in $(seq 0 2 10);do
        echo $i
    done
    # +++++++++
    # array
    a=(1 2 3 4 5)
    for i in ${a[*]};do
        echo $i
    done
    # ++++++++
    # c syntax
    for((i=0;i<10;i++));do
        echo $i
    done
    # ++++++++
    for i in $(seq 1 5);do
       echo $i
    done
    # ++++++++
    while true;do     # while [ 1 ]
        sleep 3600
    done
    # 循环读取文件
    while read line;do
        echo ${line}
    done < file_name
}

# 脚本入口
main(){
    res=$(func3)    #获取函数返回值
    echo "this is from ${res}"
}


#
operater() {
    # 算术运算: +  -  *  /  %  **
    let "a=2**2"  # a == 4

    # 算术赋值运算: +=  -=  *=  /=  %=
    let "a+=2"

    # 逻辑运算: !  -a   -o  &&  ||

    # 位运算: <<  >>  &  |  ~  ^  <<=  >>=  &=  |=  ^=
    let "a=2<<2"

    # 自赠 自减: ++  --
    let "a++"
    let "++a"
    # 数字常量默认是十进制
    # 八进制: 0为前缀
    # 十六进制: 0x为前缀
    # 使用num#标记进制数
    num=20
    let "8#${num}"    # 超出数值范围会报错

}
main "$@"
