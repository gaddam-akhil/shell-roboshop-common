#!/bin/bash
source ./common.sh


APP_NAME=mysql
check_root



dnf install mysql-server -y &>>$LOGS_FILES
VALIDATE $? "Installing mysql"

systemctl enable mysqld &>>$LOGS_FILES
VALIDATE $? "ENABLE MYSQL"

systemctl start mysqld  &>>$LOGS_FILES
VALIDATE $? "START MYSQL"
#get the password from user
mysql_secure_installation --set-root-pass RoboShop@1 &>>$LOGS_FILES
VALIDATE $? "setup root PASWORD"

print_total_time