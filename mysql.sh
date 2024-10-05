#!/bin/bash 

USER=$( id -u )
TIME_STAMP=$( date +%F-%D-%M-%S )
SCRIPT=$( echo $0 | cut -d "." / -f1 )
LOG=$SCRIPT-$TIME_STAMP

echo " current file name is" $LOG