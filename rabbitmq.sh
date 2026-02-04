#!/bin/bash

APP_NAME=rabbitmq
source ./common.sh

check_root

cp $SCRIPT_DIR/$APP_NAME.repo  /etc/yum.repos.d/$APP_NAME.repo
VALIDATE $? "ADDING REPO FILE"

dnf install $APP_NAME-server -y &>>$LOGS_FILES
VALIDATE $? "Installing $APP_NAME sever"

systemctl enable $APP_NAME-server &>>$LOGS_FILES
systemctl start $APP_NAME-server &>>$LOGS_FILES
VALIDATE $? "ENABLING AND STARTING SERVER"

$APP_NAMEctl add_user roboshop roboshop123 &>>$LOGS_FILES
$APP_NAMEctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOGS_FILES
VALIDATE $? "ADDING USER AND SETTING PERMISSION"