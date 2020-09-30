#!/bin/bash
# ttest.sh


if [ $(ps aux | grep ttest.sh | grep -v grep | wc -l) -gt 2 ];then
    echo "ttest.sh is running"
    exit
fi

ttest(){
    echo "test"
    sleep 100
}
ttest
echo "aaa"
