#!/bin/bash 

USER=$(id -u)
TIME_STAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
he=$SCRIPT_NAME-$TIME_STAMP
LOG_FILE=/tmp/$he.log
# 
VALIDATE(){
    if [ $1 -eq 0 ]
    then 
        echo "$2 done successfully"
    else
        echo "$2 failure..."
    fi 
}

if [ $USER -eq 0 ]
then 
    echo "you are the super user"
else  
    echo "need super user access to do"
fi 

dnf install mysql-server -y &>> LOG_FILE
VALIDATE $? "installing mysql-server"

systemctl enable mysqld &>> LOG_FILE
VALIDATE $? "enabling mysqld"

systemctl start mysqld &>> LOG_FILE
VALIDATE $? "starting mysqld"

mysql_secure_installation --set-root-pass ExpenseApp@1 
VALIDATE $? "setting up the Password"


