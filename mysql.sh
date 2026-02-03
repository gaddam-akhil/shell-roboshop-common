#!/bin/bash

APP_NAME=mysql
source ./common.sh

check_root



dnf install mysql-server -y &>>$LOGS_FILES
VALIDATE $? "Installing mysql"

systemctl enable mysqld &>>$LOGS_FILES
systemctl start mysqld  &>>$LOGS_FILES
VALIDATE $? "ENABLE AND START MYSQL"

mysql_secure_installation --set-root-pass RoboShop@1 &>>$LOGS_FILES
VALIDATE $? "CHANGING PASWORD"

print_total_time