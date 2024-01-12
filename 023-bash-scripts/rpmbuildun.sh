#!/bin/bash

if [ "$1" == "" ];then
        cat << EOF
Usage:
        $0 [xxxx.rpm]
EOF
        exit 0
fi

rpm2cpio "$1" | cpio -imd

