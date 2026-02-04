#!/bin/bash

APP_NAME=redis
source ./common.sh

check_root

dnf module disable redis -y &>>$LOGS_FILES
dnf module enable redis:7 -y &>>$LOGS_FILES
VALIDATE $? "enable redis" 

dnf install redis -y &>>$LOGS_FILES
VALIDATE $? "installing redis"

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e  '/protected-mode/ c protected-mode no' /etc/redis/redis.conf
VALIDATE $? "ALLOWING REMOTE CONNNECTIN"

systemctl enable redis &>>$LOGS_FILES
systemctl start redis &>>$LOGS_FILES
VALIDATE $? "start redis"

print_total_time
