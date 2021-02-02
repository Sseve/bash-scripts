#!/bin/bash
# 变量在编程语言中用来表示数据,它本身只是个标记,指向数据在内存中的一个地址或一组地址

# 变量名 variable_name
# 变量值 $variable_name

# 变量仅仅在声明,赋值,被删除(unset),被导出(export),算术运算中使用双括号结构((...))时或在代表信号才不需要$来对变量进行引用
# 变量赋值可以使用 =, 可以在read语句中, 也可以在循环的头部(for var in 1 2 3).
# 在双引号""字符串中可以使用变量替换,称之为部分引用(弱引用),而使用单引号''时,变量只会作为字符串显示,不会发生变量替换,称之为
# 全引用(强引用).

# 变量赋值
a=100
let a=1+2

# 使用``或$(...)进行命令替换
b=`ls -l`  # 等价 b=$(ls -l)

# 局部变量, 仅仅在代码块或者函数中才可见的变量

# 环境变量, 会影响用户及shell行为的变量

# 位置参数，从命令行传递给脚本的参数: $0, $1, $2, $3 ... ${10}, ${11} ...
# $0: 脚本名称
# $*: 所有位置参数,视为一个单词
# $@: 所有位置参数,但其中每个参数都是独立的被引用的字符串
# $#: 传入参数个数
# ${!#}: 命令行的最后一个参数
# 为了避免命令行传入参数时,忘记传值,使用: variable=${1:-$Default}
# shift可以将命令行参数全体左移位, $0不变,原来的$1会消失; 默认移动一位,可以指定移动量 shift $n

# 变量引用时通常建议将变量包含在双引号中,这样可以防止除了$,`(反引号),\(转义符)之外的其他特殊字符被重新解释
# 双引号可以防止字符串被分割,如下:
list="one two three"
for i in $list;do
    echo "$i"
done
# ones
# two
# three
for i in "$list";do
    echo "$i"
done
# one two three

# 变量类型标注
# declare/typest命令选项
declare -r num=100        # 声明只读变量
declare -i num            # 声明整形变量
declare -a arr            # 声明数组
declare -f fun            # 列出函数
declare -x index=200      # 该语句声明了变量index可以导出到该变量所属脚本之外的 shell 环境中
declare -l aa             # 声明一个局部变量   等价于  local aa=300

# --------
# 内部变量
# $BASH                Bash程序的路径
# $BASH_ENV            这个环境变量会指向一个 Bash 启动文件,该文件在脚本被调用时会被读取
# $BASH_SUBSHELL       该变量用于提示所处的subshell层级.这是在Bash version 3中被引入的新特性
# $BASHPID             当前 Bash 进程实例的进程ID号.虽然与 $$ 变量不一样,但是通常它们会给出相同的结果
# $BASH_VERSINFO[n]    这是一个6个元素的数组,其中包含了已经安装的 Bash 的版本信息,该变量与变量 $BASH_VERSION 类似,但是更加详细 与 $MACHTYPE 相同
# $BASH_VERSION        已经安装的 Bash 的版本信息
# $CDPATH              变量指定 cd 命令可以搜索的路径，路径之间用冒号进行分隔。该变量的功能类似于指定可执行文件搜索路径的变量 $PATH
# $DIRSTACK            指代目录栈中顶部的值，目录栈由命令 pushd 和 popd 控制.该变量相当于命令 dirs，但是 dirs 命令会显示整个目录栈
# $EUID                有效用户ID,有效用户ID（EUID）是指当前用户正在使用的用户ID，可以通过 su 命令修改
# $FUNCNAME            当前运行函数的函数名
# $GLOBIGNORE          在文件匹配时所忽略的文件名模式列表
# $GROUPS              当前用户所属的用户组.内容与记录在文件 /etc/passwd 和文件 /etc/group 中的一致。
# $HOME                当前用户的主目录，其值通常为 /home/username
# $HOMENAME            系统启动的初始化脚本通过命令 hostname 给系统分配主机名。而函数 gethostname() 则是给 Bash 的内部变量 $HOSTNAME 赋值。
# $HOSTTYPE            主机类型。类似变量 $MACHTYPE，用于识别系统硬件信息
# $IFS                 内部字段分隔符.该变量决定了 Bash 在解析字符串时如何去识别 字段 或单词边界.$IFS 的缺省值是空白符（空格，制表符以及换行符），但其可以被修改. $* 使用保存在 $IFS 中的第一个字符
# $LINENO              该变量记录了其在脚本中被使用时所处行的行号。该变量只有在被使用时才有意义，在调试过程中非常有用。
# $IGNOREEOF           忽略 EOF：用于指示 Shell 在注销前需要忽略多少个文件结束符(EOF，contrl-D)。
# $LC_COLLATE          经常会在文件 .bashrc 或是文件 /etc/profile 中被设置。该变量控制文件名扩展和模式匹配中的排序顺序。如果设置不得当，LC_COLLATE 将会导致 文件名匹配 中出现非预期结果
# $LC_CTYPE            这个内部变量控制在 文件匹配 和模式匹配中的字符解析行为
# $OLDPWD              上一个工作目录(OLD-Print-Working-Directory)，也就是之前所在的目录。
# $OSTYPE              操作系统类型
# $PATH                可执行文件搜索路径，其值通常包含 /usr/bin，/usr/X11R6/bin/，/usr/local/bin 等路径
# $PIPESTATUS          该 数组 变量保存了最后运行的前台 管道 的 退出状态(es)
# $PPID                一个进程的 $PPID 即该进程的父进程的进程ID(pid)。
# $PROMPT_COMMAND      该变量存储在主提示符 $PS1 显示之前所需要执行的命令
# $PS1                 主提示符，即在命令行中显示的提示符
# $PS2                 次要提示符，当需要额外输入时出现的提示符。默认显示为 >
# $PS3                 三级提示符，显示在 select 循环中
# $PS4                 四级提示符，当使用 -x [verbose trace] 选项 调用脚本时显示的提示符。默认显示为 +
# $PWD                 工作目录（你当前所在的目录）
# $REPLY               当没有给 read 命令提供接收参数时的默认接收参数。该变量同样适用于 select 菜单接收用户输入值的场景，需要注意的是，用户只需要输入菜单项的编号，而不需要输入完整的菜单项内容。
# $SECONDS             该变量记录到目前为止脚本执行的时间，单位为秒
# $SHELLOPTS           该只读变量记录了 shell 中已启用的 选项 列表
# $SHLVL               当前 shell 的层级，即嵌套了多少层 Bash 。如果命令行的层级 $SHLVL 为 1，那么在其中执行的脚本层级则增加到 2。
# $TMOUT               如果 $TMOUT 被设为非 0 值 time，那么 shell 会在 $time 秒后超时，然后导致 shell 登出
# $UID                 用户 ID.记录在文件 /etc/passwd 中当前用户的用户标识号
# $!                   运行在后台的最后一个任务的 进程ID
# $_                   该变量被设置为上一个执行的命令的最后一个参数
# $?                   命令、函数 或是脚本自身的 退出状态
# 


# 以C风格的方式操作变量，使用(( ... ))结构
(( a = 23 ))  #  C风格的变量赋值，注意"="等号前后都有空格
echo "a (initial value) = $a"   # 23
(( a++ ))     #  后缀自增'a'，C-style.
echo "a (after a++) = $a"       # 24
(( a-- ))     #  后缀自减'a', C-style.
echo "a (after a--) = $a"       # 23

(( ++a ))     #  前缀自增'a', C-style.
echo "a (after ++a) = $a"       # 24
(( --a ))     #  前缀自减'a', C-style.
echo "a (after --a) = $a"       # 23

########################################################
#  注意，C风格的++，--运算符，前缀形式与后缀形式有不同的
#+ 副作用。

n=1; let --n && echo "True" || echo "False"  # False
n=1; let n-- && echo "True" || echo "False"  # True

(( t = a<45?7:11 ))   # C风格三目运算符。
#       ^  ^ ^
echo "If a < 45, then t = 7, else t = 11."  # a = 23
echo "t = $t "                              # t = 7

# -----------
#  把 (( ... ))结构称为shell 算术运算，
#  但是这种表述并不准确...
#  (( ... )) 结构在Bash 2.04版本之后才能正常工作。


# 优先级
# 先乘除取余，后加减，与算数运算相似
# 复合逻辑运算符，&&, ||, -a, -o 优先级较低
# 优先级相同的操作按从左至右顺序求值