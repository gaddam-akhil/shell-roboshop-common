#!/bin/bash

source ./common.sh

APP_NAME=frontend
check_root

dnf module list nginx &>>$LOGS_FILES
VALIDATE $? "MODULE LIST NGINX"

dnf module disable nginx -y &>>$LOGS_FILES
dnf module enable nginx:1.24 -y &>>$LOGS_FILES
VALIDATE "ENABLE NGINX MODULE"

dnf install nginx -y &>>$LOGS_FILES
VALIDATE $? "installing nginx"

systemctl enable nginx &>>$LOGS_FILES
systemctl start nginx &>>$LOGS_FILES
VALIDATE $? "ENABLE AND START NGINX"

rm -rf /usr/share/nginx/html/* 
VALIDATE $? "removing default file"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>>$LOGS_FILES
VALIDATE $? "downloading frontend code"

cd /usr/share/nginx/html &>>$LOGS_FILES
VALIDATE $? "Moving html file"

unzip /tmp/frontend.zip &>>$LOGS_FILES
VALIDATE $? "Unzipping frontend file"

rm -rf /etc/nginx/nginx.conf

cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf
VALIDATE $? "coping our nginx conf file"

systemctl restart nginx &>>$LOGS_FILES
VALIDATE $? "restarting nginx"

print_total_time