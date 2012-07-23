#!/bin/bash

function ctrl_c() {
    #kill ./server.sh
    kill %+
    #kill test driver
    ps xu | grep node | grep -v grep | awk '{print $2 }' | xargs kill -9
    echo "** Trapped CTRL-C"
    exit 0
}
trap ctrl_c INT
trap ctrl_c EXIT

buster server