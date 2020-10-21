#!/usr/bin/env bash

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
