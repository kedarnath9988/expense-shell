#!/bin/bash 
USER=$( id -u )
TIME_STAMP=$( date +%F-%H-%M-%S )
SCRIPT_NAME=$( echo $0 |cut -d "." -f1)
LOG_FILE=/tmp/$SCRIPT_NAME-$TIME_STAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
VALIDATE(){
    if [$1 -eq 0]
    then
        echo -e "$G $2 done successfully..$N"
    else
        echo -e "$R $2 failure ..$N"
        exit 1 
    fi 
}
if [ USER -eq 0 ]
then
    echo -e "$G You are super-user $N"
else 
    echo -e "$R need super user access $N"
    exit 1 # manually exit 
fi


dnf install nginx -y &>>$LOG_FILE
VALIDATE $? "installing nginx"

systemctl enable nginx &>>$LOG_FILE
VALIDATE $? "enabling nginx"

systemctl start nginx &>>$LOG_FILE
VALIDATE $? "starting nginx"

rm -rf /usr/share/nginx/html/* &>>$LOG_FILE
VALIDATE $? "removing the default content"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOG_FILE
VALIDATE $? "downlode the frontend code"

cd /usr/share/nginx/html &>>$LOG_FILE
VALIDATE $? "moving to default html directory "

unzip /tmp/frontend.zip &>>$LOG_FILE
VALIDATE $? "unziping the frontend code"

cp /home/ec2-user/expense-shell/expense.conf /etc/nginx/default.d/expense.conf &>>$LOG_FILE
VALIDATE $? "coping the frontend service"

systemctl restart nginx &>>$LOG_FILE
VALIDATE $? "restarting the nginx service" 
