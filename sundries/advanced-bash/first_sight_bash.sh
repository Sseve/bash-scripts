#!/bin/bash
# cleanup log

LOG_DIR=/var/log    
ROOT_UID=0          # UID为0的用户才拥有root权限
LINES=50            # 默认保存messages日志文件行数
E_XCD=86            # 无法切换工作目录的错误码
E_NOTROOT=87        # 非root权限用户执行的错误码

# 请使用root权限运行
if [ "$UID" -ne "$ROOT_UID"]; then
    echo "Must be root to run this script."
    exit $E_NOTROOT
fi

# 测试命令行参数(保存行数）是否为空
if [ -n "$1" ]; then
    lines=$1
else
    lines=$LINES    # 如果为空设置使用默认值
fi

# 建议使用如下方法检查命令行参数.
#  E_WRONGARGS=85      # Non-numberical argument(bad argument format).
#  case "$1" in
#    "")
#    lines=50
#    ;;
#    *[!0-9*])
#    echo "Usage: `basename $0` lines-to-cleanup";
#    exit $E_WRONGARGS
#    ;;
#    *)
#    lines=$1
#    ;;
#  esac

# 清理日志前再次确认是否在正确的工作目录下
cd $LOG_DIR
if [ `pwd` != "$LOG_DIR" ]; then    # 也可以这样写 if [ "$PWD" != "$LOG_DIR" ]
    echo "Can't change to $LOG_DIR"
    exit $E_XCD
fi

# 更高效的写法
# cd $LOG_DIR || {
#     echo "Can't change to necessary directory." >&2
#     exit $E_XCD    
# }

# 保留messages日志文件的最后一部分
tail -n $lines messages > mesg.temp
# 替换系统日志文件以达到清理目的
mv mesg.temp messages

echo "Log files cleaned up." 

exit 0