#!/bin/bash

source ./common.sh

check_root

cp mongo.repo  /etc/yum.repos.d/mongo.repo
VALIDATE $? "coping mongo repo"

dnf install mongodb-org -y &>>$LOGS_FILES
VALIDATE $? "installing mongodb server"

systemctl enable mongod &>>$LOGS_FILES
VALIDATE $? "enable mongodb" 

systemctl start mongod &>>$LOGS_FILES
VALIDATE $? "start mongodb"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE $? "allowing remote connection"

systemctl restart mongod &>>$LOGS_FILES
VALIDATE $? "restart mongodb"

print_total_time()