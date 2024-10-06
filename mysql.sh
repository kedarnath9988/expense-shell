#!/bin/bash 

USER=$(id -u)
TIME_STAMP=$(date +%F-%H-%M-S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
he=$SCRIPT_NAME-$TIME_STAMP
echo "printing the " $he

