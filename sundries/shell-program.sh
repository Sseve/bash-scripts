#!/bin/bash

# shell base


##### 正则表达式 #####
# 以下的正则字符适用于shell命令如grep,awk,sed(bash本身不支持正则表达,但支持一些通配符)
# 普通字符: 字符表达的意义就是其本身, 如: 字符a就是表达字符a的意思
# 元字符: 字符表达的意义有特殊含义, 
#        * -- 多个在*字符之前的那个普通字符
#        . -- 匹配任意一个字符
#        ^ -- 匹配行首,表示行首是^后面的那个字符
#        $ -- 匹配行尾,表示行尾是$前面的那个字符
#       ^$ -- 匹配空行
#      ^.$ -- 匹配一个字符的行
#       [] -- 匹配字符集合,支持穷举表示,范围表示,如:[abcde]或者[a-e],表示匹配a到e中的一个字符
#      [^] -- 取反[]中的字符,即匹配除了[]中以外的任意字符
#        \ -- 转义符号,用于屏蔽元字符的特殊意义.
#     \<\> -- 精确匹配,如 \<the\>匹配the这个单词  
#     \{\} -- 匹配前一个字符重复的次数，如: \{n\}匹配前一个字符出现n次;\{n,\}匹配前一个字符至少出现n次,\{n,m\}匹配前一个字符出现n到m次
# 正则表达式扩展:
#        ? -- 匹配前一个字符0次或1次
#        + -- 匹配前一个字符1次或多次
#       () -- 与|结合使用表示一组可选的字符集合,如:lov(1|2|3)e,表示匹配lov1e,lov2e,lov3e
#        | -- 表示多个正则表达式的或关系, re1 | re2 | re3

##### bash通配符 #####
#        * -- 表示任意位置的任意字符
#        ? -- 表示任意一个字符
#        ^ -- 取反
#       [] -- 表示某个范围内
#      [^] -- 表示某个范围以外
#       {} -- 表示一组表达式的集合, {[a-z]*.txt, b?.sh}

##### 变量 #####
# 单引号内的字符不能表达特殊意义;双引号内的字符可以表达特殊的意义,并且可以进行变量替换
# 本地变量: 用户当前shell生命周期的脚本中使用的变量,会随着shell消亡而无效,在新启动的shell也无效
# 环境变量：环境变量在用户登陆到注销之前对所有编辑器,脚本,程序和应用都有效(env命令查看当前环境变量的值)
# 位置参数: 用于向shell脚本传递参数 $0 $1 $2 ...${10} $@ $* $# $? $$
# shell变量同时有数值型和字符型两种,数值型初始值是0,字符型初始值为空,而且可以不用事先定义就直接使用.
# 变量赋值: var_name=value 或者 ${va_name=value}
# 取变量的值: ${variable}
# unset 变量名  --  清除变量的值
#          :=  --  对已经赋值过的变量不再赋值,如果变量没有赋值就给变量赋值并保留值,如: ${colour:=red}  echo ${colour} => red
#          :-  --  对已经赋值过的变量不再赋值,如果变量没有赋值就给变量赋值但不保留,如: ${colour:-red}  echo ${colour} => 什么都没有，为空
#      :?或者?  --  测试变量是否被赋值,如果没赋值会报错
#    readonly  --  设置只读变量, colour=black && readonly colour 或者 declare -r colour=red 或者 typeset -r colour=green
# shell脚本变量默认是字符型,空字符串还具有一个整型值0;如果变量值包含数字则该变量是数值型,否则是字符串型.
# 环境变量定义: export var_name
# 常见环境变量:
#       PWD  --  当前目录的路径
#    OLDPWD  --  用户前一个所处目录路径
#      PATH  --  记录一些可执行命令或脚本的环境变量
#      HOME  --  记录当前用户的根目录
#      USER  --  当前用户名字
#       UID  --  当前用户ID
#      PPID  --  当前进程号
#       IFS  --  指定shell域分隔符号,默认空格
# 相关环境变量的配置文件: .bash_profile, .bashrc, .bash_logout, profile
# #
# 间接变量引用:
#       a=b && b=c
#       eval t=\$$a 或者 t=${!a}


##### 测试，判断 #####
# 测试： test expression 或者 [ expression ]
# 整数比较: -eq, -ge, -gt, -le, -lt, -ne
# 字符串运算: 
#       测试字符串是否不为空  --  test "${string}" 或者 [ -n "${string}" ]
#       测试字符串是否为空    --  [ -z "${string}" ]
#       测试字符串是否相同    --  [ "${string1}" = "${string2}" ] 或者 [ "${string1}" == "${string2}" ]
#       测试字符串是否不同    --  [ "${string1}" != "${string2}" ]
# 文件操作:
#       测试文件是否是目录       --  [ -d ${file} ]
#       测试文件是否存在         --  [ -e ${file} ]
#       测试文件是否是普通文件    --  [ -f ${file} ]
#       测试文件是否是进程可读    --  [ -r ${file} ]
#       测试文件长度是否为0      --   [ -s ${file} ]
#       测试文件是否是进程可写    --  [ -w ${file} ]
#       测试文件是否是进程可执行  --  [ -x ${file} ]
#       测试文件是否符号化链接    --  [-L ${file} ]
# 逻辑操作: 
#       !     ! expression
#       -a    expression1 -a expression2 -a expression3  
#       -o    expression1 -o expression2 -o expression3
#       &&    [ test1 ] && [ test2 ]
#       ||    [ test1 ] || [ test2 ]

##### 结构控制 #####
# 判断:
# if [ expression ];then
#     command
#     ...
# fi
# # #
# if [ expression ];then
#     command
#     ...
# else
#     command
#     ...
# fi
# # #
# if [ expression ];then
#     command
#     ...
# elif [ expression ];then
#     command
#     ...
# else
#     command
#     ...
# fi
## 注意:(())可以用作数值比较, if((a>b)) && ((a<c)); 一般用二元比较可以用[[ ]]代替[ ]
# case结构:
# case var in
#     var1)
#     command
#     ;;
#     var2)
#     command
#     ;;
#     *)
#     command
#     ;;
# esac
# #
# for循环
# for var in {list};do     # list形式 {1..5..2}, $(seq 1 100 2), 数组
#    command
#     ...
# done
# # 
# for argumet in "$@";do   # 遍历命令行参数
#   command
#     ...
# done
# # 
# for(( expr1; expr2; expr3));do    # expr可以是逗号分隔的多个表达式
#     command
#     ...
# done
# # #
# while expression;do
#     command
#     ...
# done
# #
# while [[ "$*" != "" ]];do    # 控制命令行
#     echo "$1"
#     shift
# done 
# #
# until [[ expression ]];do
#     command
#     ...
# done
# # 
# 循环控制: break  continue
# #
# select结构: 
# select var in {list};do
#     command
#     ...
#     if [ expression ];then
#         break
#     fi
# done

##### 字符串处理 => expr命令 #####
# aa="i love china"
# 求字符串长度:  ${#aa} 或者 expr length ${aa}
# 索引子串位置:  expr index ${aa} ${substring}
# 匹配字串: expr match ${aa} ${substring}
# 抽取字串: #{string:position:length} 或者 expr substr ${aa} position length     # 也可以从右边开始抽取
# 删除字串: ${string#substring}, ${string##substring}, ${string%substring}, ${string%%substring}
# 替换字串: ${string/substring/replacement}, ${string//substring/replacement}, ${string/#substring/replacement}, ${string/%substring/replacement}

##### I/O重定向 #####
# 管道符号: |     --     command1 | command2
# 标准输入: stdin   0
# 标准输出: stdout  1
# 标准错误: stderr  2
# 重定向符号: >  >>  <  <<  -<<  2>&1
# exec命令: 通过文件标识符打开或者关闭文件，或者将文件重定向到stdin, stdout;
#     >filename      --      将标准输出写入到文件filename中
#     <filename      --      将文件filename的内容读入到标准输入中
#    >>filename      --      将标准输出写到文件filename中，如果文件存在则追加到文件filename末尾
#    >|filename      --      强制覆盖文件filename的内容
#   n>|filename      --      强制将FD为n的输出写入到filename中,并覆盖filename
#    n>filename      --      将FD为n的输出写入到文件filename中,如noclobber选项存在则不能成功
#    n<filename      --      将文件filename的内容读入到FD为n的描述符中
#   n>>filename      --      将FD为n的输出写入到filename中,若文件存在则追加到末尾  
#          <<EO      --      标记此处文档开始 
#          n>&m      --      将FD为m的输出复制到FD为n的文件中
#          n<&m      --      将FD为m的输入复制到FD为n的文件中
#          n>&-      --      关闭FD为n的输出
#          n<&-      --      关闭FD为n的输入
#        &>file      --      将标准输出和标准错误重定向到文件file中