#!/bin/bash 

USER=$( id -u )
TIME_STAMP=$( date +%F-%D-%M-%S )
SCRIPT=$( echo $0 | cut -d "." -f1 )
LOG=/tmp/$SCRIPT-$TIME_STAMP

if [ $USER -eq 0 ]
then 
    echo "you are the super user "
else
    echo "need super user access"
    exit 1 # manually exing 
fi 
VALIDATE()
    if [ $1 -eq 0 ]
    then
        echo "$2 done successflly"
    else
        echo "$2 failed .. "
        exit 1 # manually exiting 
    fi 

dnf install mysql-server -y &>> LOG
VALIDATE $? "installing mysql server"

systemctl start mysqld &>> LOG
VALIDATE $? "starting mysql "

systemctl enable mysqld &>> LOG
VALIDATE $? "enabling mysql "

mysql_secure_innstallation  --set -root-password ExpenseApp@1 
VALIDATE  $? "settinng the root password"

