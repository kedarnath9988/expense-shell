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
        exit 1 
    fi 
}

if [ $USER -eq 0 ]
then 
    echo "you are the super user"
else  
    echo "need super user access to do"
    exit 1 
fi 

dnf install mysql-server -y &>> LOG_FILE
VALIDATE $? "installing mysql-server"

systemctl enable mysqld &>> LOG_FILE
VALIDATE $? "enabling mysqld"

systemctl start mysqld &>> LOG_FILE
VALIDATE $? "starting mysqld"

mysql -h db.dawskedarnath.online -uroot -pExpenseApp@1 -e 'SHOW DATABASES;' &>> LOG_FILE
if [ $? -eq 0 ]
then 
    echo "password already setuped SKPPING "
else
    mysql_secure_installation --set-root-pass ExpenseApp@1 &>> LOG_FILE
    VALIDATE $? "setting up the root password"
fi 


#mysql_secure_installation --set-root-pass ExpenseApp@1 &>> LOG_FILE
#echo "setting up the Password"

