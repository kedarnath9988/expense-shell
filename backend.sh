#!/bin/bash

USER=$(id -u)
TIME_STAMP=$(data +%F-%H-%M-%S)
SCRIPT_NAME=$( echo $0 | cut -d "." -f1 )
LOG_FILE=/tmp/$SCRIPT_NAME-$SCRIPT_NAME.log

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE(){
    if [ $1 -eq 0 ]
    then
        echo -e "$G $2 done successfully ..$N"
    else
        echo -e "$R failure .. $N"
        exit 1  # manually exiting
    fi
}

if [ $USER -eq 0 ]
then
    echo -e "$G you are super user $N"
else
    echo -e "$R need super user access to do  $N"
    exit 1 # manually exiting 
fi 

dnf module disable nodejs:18 -y &>>$LOG_FILE
VALIDATE $? "diasbling nodejs"

dnf module enable nodejs:20 -y &>>$LOG_FILE
VALIDATE $? "enabling nodejs"

dnf install nodejs -y &>>$LOG_FILE
VALIDATE $? "installing nodejs"

id expense &>>$LOG_FILE
if [ $? -eq 0 ]
then
    echo -e "$G user already existed $N"
else
     useradd expense &>>$LOG_FILE
     echo -e "$R creating Expence user $N"
fi 

mkdir -p /app &>>$LOG_FILE
VALIDATE $? "creating /app directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOG_FILE
VALIDATE $? "downlode backend code"

cd /app &>>$LOG_FILE
VALIDATE $? "moving to /app directory"

unzip /tmp/backend.zip &>>$LOG_FILE
VALIDATE $? "unzip the backend code"

cd /app &>>$LOG_FILE
VALIDATE $? "moving to /app directory"

npm install &>>$LOG_FILE
VALIDATE $? "installing node packages"

cp /home/ec2-user/expense-shell/backend.service /etc/systemd/system/backend.service &>>$LOG_FILE
VALIDATE $? "coping the backend.service"

systemctl daemon-reload &>>$LOG_FILE
VALIDATE $? "daemon reload "

systemctl enable backend &>>$LOG_FILE
VALIDATE $? "enable backend"

systemctl start backend &>>$LOG_FILE
VALIDATE $? "start backend"

dnf install mysql -y &>>$LOG_FILE
VALIDATE $? "installing mysql clint"

systemctl restart backend &>>$LOG_FILE
VALIDATE $? "restarting backend"


