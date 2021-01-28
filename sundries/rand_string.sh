#!/bin/bash

# 随机字符串产生

# 字符串长度
length=18

# 计数器
counter=1

# 字符串组成的序列
seq=(0 1 2 3 4 5 6 7 8 9 a b c d e f g h i j k l m n o p q r s t u v w x y z A B C D E F G H I J K L M N O P Q R S T U V W X Y Z)

# 字符串序列长度
num_seq=${#seq[@]}

while [[ "$counter" -le "$length" ]];do
    seq_rand[$counter]=${seq[$((RANDOM%num_seq))]}
    let "counter=counter+1"
done

echo "random string is:"
for n in ${seq_rand[@]};do
    echo -n $n
done
echo
