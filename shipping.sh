#!/bin/bash

source ./common.sh
APP_NAME=shipping

check_root
app_setup
java_setup
systemd_setup

dnf install mysql -y &>>$LOGS_FILES
VALIDATE $? "Installing Mysql"

mysql -h $MYSQL_HOST -uroot -pRoboShop@1 -e 'use cities'

if [ $? -ne 0 ]; then
mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/schema.sql
mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/app-user.sql 
mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/master-data.sql
VALIDATE $? "LOADING SCHEMAS"
else
echo -e "data is already loaded.... $Y SKIPPING $N"
fi

app_restart
print_total_time