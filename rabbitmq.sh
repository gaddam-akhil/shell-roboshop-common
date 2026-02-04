#!/bin/bash

source ./common.sh

APP_NAME=rabbitmq
check_root

cp $SCRIPT_DIR/rabbitmq.repo  /etc/yum.repos.d/rabbitmq.repo
VALIDATE $? "ADDING REPO FILE"

dnf install rabbitmq-server -y &>>$LOGS_FILES
VALIDATE $? "Installing rabbitmq sever"

systemctl enable rabbitmq-server &>>$LOGS_FILES
systemctl start rabbitmq-server &>>$LOGS_FILES
VALIDATE $? "ENABLING AND STARTING SERVER"

rabbitmqctl add_user roboshop roboshop123 &>>$LOGS_FILES
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOGS_FILES
VALIDATE $? "ADDING USER AND SETTING PERMISSION"

print_total_time